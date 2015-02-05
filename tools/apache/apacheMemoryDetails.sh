#!/bin/bash

echo "実行はrootのみ"

sudo echo "" > /tmp/test.log 

echo -e "ALLOCATABLE_MEMORY\t" >> "/tmp/test.log"
cat /proc/meminfo \
| awk '
	BEGIN{memfree=0;inactive=0}
	/MemFree/{memfree=$2;}
	/Inactive/{inactive=$2;}
	END{printf("%.1f\n",(memfree+inactive)/1024 ) >> "/tmp/test.log";}';







echo -e "PID\tPPID\tVmHWM\tRSS\tSHARED\tPRIVATE\tRATE\t" >> "/tmp/test.log"
ps -ef | grep [a]pache2 | while read line
do
    args=(${line})
    echo -ne ${args[1]}"\t"${args[2]}"\t" >> "/tmp/test.log"
    cat /proc/${args[1]}/smaps /proc/${args[1]}/status \
| awk '
        BEGIN{rss=0;shared=0;vmhvm=0;count=0}
        /Rss/{rss+=$2;}
        /Shared/{shared+=$2;}
	/VmHWM/{vmhwm=$2;}
	#/apache2/{count++;}
        END{printf("%.1f\t%.1f\t%.1f\t%.1f\t%.1f\n",vmhwm/1024,rss/1024,shared/1024,(rss-shared)/1024,shared/rss*100 ) >> "/tmp/test.log";}';
done

cat /tmp/test.log



#20130305・・・つづきプロセス数取得しPRIVATEメモリの平均を出す。それをもとにMAXCLIENTS推奨値を算出・出力
