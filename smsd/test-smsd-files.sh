#!@SH_BIN@

set -x
set -e
SMSD_PID=0

INBOXF="$1"
SERVICE="files-$INBOXF"

echo "NOTICE: This test is quite tricky about timing, if you run it on really slow platform, it might fail."
echo "NOTICE: Testing service $SERVICE"

cleanup() {
    if [ $SMSD_PID -ne 0 ] ; then
        kill $SMSD_PID
        sleep 1
    fi
}

trap cleanup INT QUIT EXIT

cd @CMAKE_CURRENT_BINARY_DIR@

rm -rf smsd-test-$SERVICE
mkdir smsd-test-$SERVICE
cd smsd-test-$SERVICE

# Dummy backend storage
mkdir gammu-dummy
# Create config file
cat > .smsdrc <<EOT
[gammu]
model = dummy
connection = none
port = @CMAKE_CURRENT_BINARY_DIR@/smsd-test-$SERVICE/gammu-dummy
gammuloc = /dev/null
loglevel = textall

[smsd]
commtimeout = 5
debuglevel = 255
logfile = stderr
runonreceive = @CMAKE_CURRENT_BINARY_DIR@/smsd-test-$SERVICE/received.sh
service = files
inboxpath = @CMAKE_CURRENT_BINARY_DIR@/smsd-test-$SERVICE/inbox/
outboxpath = @CMAKE_CURRENT_BINARY_DIR@/smsd-test-$SERVICE/outbox/
sentsmspath = @CMAKE_CURRENT_BINARY_DIR@/smsd-test-$SERVICE/sent/
errorsmspath = @CMAKE_CURRENT_BINARY_DIR@/smsd-test-$SERVICE/error/
inboxformat = $INBOXF
transmitformat = auto
EOT
mkdir -p @CMAKE_CURRENT_BINARY_DIR@/smsd-test-$SERVICE/inbox/
mkdir -p @CMAKE_CURRENT_BINARY_DIR@/smsd-test-$SERVICE/outbox/
mkdir -p @CMAKE_CURRENT_BINARY_DIR@/smsd-test-$SERVICE/sent/
mkdir -p @CMAKE_CURRENT_BINARY_DIR@/smsd-test-$SERVICE/error/

cat > @CMAKE_CURRENT_BINARY_DIR@/smsd-test-$SERVICE/received.sh << EOT
#!@SH_BIN@
echo "\$@" >> @CMAKE_CURRENT_BINARY_DIR@/smsd-test-$SERVICE/received.log
EOT
chmod +x @CMAKE_CURRENT_BINARY_DIR@/smsd-test-$SERVICE/received.sh

CONFIG_PATH="@CMAKE_CURRENT_BINARY_DIR@/smsd-test-$SERVICE/.smsdrc"
DUMMY_PATH="@CMAKE_CURRENT_BINARY_DIR@/smsd-test-$SERVICE/gammu-dummy"

mkdir -p $sms $DUMMY_PATH/sms/1
mkdir -p $sms $DUMMY_PATH/sms/2
mkdir -p $sms $DUMMY_PATH/sms/3
mkdir -p $sms $DUMMY_PATH/sms/4
mkdir -p $sms $DUMMY_PATH/sms/5

@CMAKE_CURRENT_BINARY_DIR@/gammu-smsd@GAMMU_TEST_SUFFIX@ -c "$CONFIG_PATH" &
SMSD_PID=$!

sleep 5

for sms in 62 68 74 ; do
    cp @CMAKE_CURRENT_SOURCE_DIR@/../tests/at-sms-encode/$sms.backup $DUMMY_PATH/sms/1/$sms
done

# Inject messages
cp @CMAKE_CURRENT_SOURCE_DIR@/tests/OUT* @CMAKE_CURRENT_BINARY_DIR@/smsd-test-$SERVICE/outbox/

sleep 5

for sms in 10 16 26 ; do
    cp @CMAKE_CURRENT_SOURCE_DIR@/../tests/at-sms-encode/$sms.backup $DUMMY_PATH/sms/3/$sms
done

TIMEOUT=0
while ! @CMAKE_CURRENT_BINARY_DIR@/gammu-smsd-monitor@GAMMU_TEST_SUFFIX@ -C -c "$CONFIG_PATH" -l 1 -d 0 | grep -q ";999999999999999;3;6;0;100;42" ; do
    @CMAKE_CURRENT_BINARY_DIR@/gammu-smsd-monitor@GAMMU_TEST_SUFFIX@ -C -c "$CONFIG_PATH" -l 1 -d 0
    sleep 1
    TIMEOUT=$(($TIMEOUT + 1))
    if [ $TIMEOUT -gt 60 ] ; then
        echo "ERROR: Wrong timeout!"
        exit 1
    fi
done

sleep 5

@CMAKE_CURRENT_BINARY_DIR@/gammu-smsd-monitor@GAMMU_TEST_SUFFIX@ -C -c "$CONFIG_PATH" -l 1 -d 0

if [ `wc -l < @CMAKE_CURRENT_BINARY_DIR@/smsd-test-$SERVICE/received.log` -ne 6 ] ; then
    echo "ERROR: Wrong number of messages received!"
    exit 1
fi
