#!/bin/bash

echo "Test Run #1" > output.txt
./../../../u/cgi_web/Tuition/cost <test_files/test_file_1.txt >temp
cmp -s temp gold_files/gold_file_1.txt
if [ $? -eq 0 ];
then
	echo "Test Run #1 has passed." >> output.txt

else
	echo "Test Run #1 has failed." >> output.txt
	echo "Expected:" >> output.txt

	cat gold_files/gold_file_1.txt >> output.txt

	echo "Result:" >> output.txt

	cat temp >> output.txt

fi
echo "Test Run #2" >> output.txt

./../../../u/cgi_web/Tuition/cost <test_files/test_file_2.txt >temp
cmp -s temp gold_files/gold_file_2.txt
if [ $? -eq 0 ];
then
	echo "Test Run #2 has passed." >> output.txt

else
	echo "Test Run #2 has failed." >> output.txt

	echo "Expected:" >> output.txt

	cat gold_files/gold_file_2.txt >> output.txt

	echo "Result:" >> output.txt

	cat temp >> output.txt

fi
echo "Test Run #3" >> output.txt

./../../../u/cgi_web/Tuition/cost <test_files/test_file_3.txt >temp
cmp -s temp gold_files/gold_file_3.txt
if [ $? -eq 0 ];
then
	echo "Test Run #3 has passed." >> output.txt

else
	echo "Test Run #3 has failed." >> output.txt

	echo "Expected:" >> output.txt

	cat gold_files/gold_file_3.txt >> output.txt

	echo "Result:" >> output.txt

	cat temp >> output.txt

fi
echo "Test Run #4" >> output.txt

./../../../u/cgi_web/Tuition/cost <test_files/test_file_4.txt >temp
cmp -s temp gold_files/gold_file_4.txt
if [ $? -eq 0 ];
then
	echo "Test Run #4 has passed." >> output.txt

else
	echo "Test Run #4 has failed." >> output.txt

	echo "Expected:" >> output.txt

	cat gold_files/gold_file_4.txt
	echo "Result:" >> output.txt

	cat temp >> output.txt

fi
echo "Test Run #5" >> output.txt

./../../../u/cgi_web/Tuition/cost <test_files/test_file_5.txt >temp
cmp -s temp gold_files/gold_file_5.txt
if [ $? -eq 0 ];
then
	echo "Test Run #5 has passed." >> output.txt

else
	echo "Test Run #5 has failed." >> output.txt

	echo "Expected:" >> output.txt

	cat gold_files/gold_file_5.txt >> output.txt

	echo "Result:" >> output.txt

	cat temp >> output.txt

fi
echo "Test Run #6" >> output.txt

./../../../u/cgi_web/Tuition/cost <test_files/test_file_6.txt >temp
cmp -s temp gold_files/gold_file_6.txt
if [ $? -eq 0 ];
then
	echo "Test Run #6 has passed." >> output.txt

else
	echo "Test Run #6 has failed." >> output.txt

	echo "Expected:" >> output.txt

	cat gold_files/gold_file_6.txt >> output.txt

	echo "Result:" >> output.txt

	cat temp >> output.txt

fi
echo "Test Run #7" >> output.txt

./../../../u/cgi_web/Tuition/cost <test_files/test_file_7.txt >temp
cmp -s temp gold_files/gold_file_7.txt
if [ $? -eq 0 ];
then
	echo "Test Run #7 has passed." >> output.txt

else
	echo "Test Run #7 has failed." >> output.txt

	echo "Expected:" >> output.txt

	cat gold_files/gold_file_7.txt >> output.txt

	echo "Result:" >> output.txt

	cat temp >> output.txt

fi
echo "Test Run #8" >> output.txt

./../../../u/cgi_web/Tuition/cost <test_files/test_file_8.txt >temp
cmp -s temp gold_files/gold_file_8.txt
if [ $? -eq 0 ];
then
	echo "Test Run #8 has passed." >> output.txt

else
	echo "Test Run #8 has failed." >> output.txt

	echo "Expected:" >> output.txt

	cat gold_files/gold_file_8.txt >> output.txt

	echo "Result:" >> output.txt

	cat temp
fi
echo "Test Run #9" >> output.txt

./../../../u/cgi_web/Tuition/cost <test_files/test_file_9.txt >temp
cmp -s temp gold_files/gold_file_9.txt
if [ $? -eq 0 ];
then
	echo "Test Run #9 has passed." >> output.txt

else
	echo "Test Run #9 has failed." >> output.txt

	echo "Expected:" >> output.txt

	cat gold_files/gold_file_9.txt >> output.txt

	echo "Result:" >> output.txt

	cat temp >> output.txt

fi
echo "Test Run #10" >> output.txt

./../../../u/cgi_web/Tuition/cost <test_files/test_file_10.txt >temp
cmp -s temp gold_files/gold_file_10.txt
if [ $? -eq 0 ];
then
	echo "Test Run #10 has passed." >> output.txt

else
	echo "Test Run #10 has failed." >> output.txt

	echo "Expected:" >> output.txt

	cat gold_files/gold_file_10.txt >> output.txt

	echo "Result:" >> output.txt

	cat temp >> output.txt

fi
echo "Test Run #11" >> output.txt

./../../../u/cgi_web/Tuition/cost <test_files/test_file_11.txt >temp
cmp -s temp gold_files/gold_file_11.txt
if [ $? -eq 0 ];
then
	echo "Test Run #11 has passed." >> output.txt

else
	echo "Test Run #11 has failed." >> output.txt

	echo "Expected:" >> output.txt

	cat gold_files/gold_file_11.txt >> output.txt

	echo "Result:" >> output.txt

	cat temp >> output.txt

fi
echo "Test Run #12" >> output.txt

./../../../u/cgi_web/Tuition/cost <test_files/test_file_12.txt >temp
cmp -s temp gold_files/gold_file_12.txt
if [ $? -eq 0 ];
then
	echo "Test Run #12 has passed." >> output.txt

else
	echo "Test Run #12 has failed." >> output.txt

	echo "Expected:" >> output.txt

	cat gold_files/gold_file_12.txt >> output.txt

	echo "Result:" >> output.txt

	cat temp >> output.txt

fi
echo "Test Run #13" >> output.txt

./../../../u/cgi_web/Tuition/cost <test_files/test_file_13.txt >temp
cmp -s temp gold_files/gold_file_13.txt
if [ $? -eq 0 ];
then
	echo "Test Run #13 has passed." >> output.txt

else
	echo "Test Run #13 has failed." >> output.txt

	echo "Expected:" >> output.txt

	cat gold_files/gold_file_13.txt >> output.txt

	echo "Result:" >> output.txt

	cat temp >> output.txt

fi
echo "Test Run #14" >> output.txt

./../../../u/cgi_web/Tuition/cost <test_files/test_file_14.txt >temp
cmp -s temp gold_files/gold_file_14.txt
if [ $? -eq 0 ];
then
	echo "Test Run #14 has passed." >> output.txt

else
	echo "Test Run #14 has failed." >> output.txt

	echo "Expected:" >> output.txt

	cat gold_files/gold_file_14.txt >> output.txt

	echo "Result:" >> output.txt

	cat temp >> output.txt

fi
echo "Test Run #15" >> output.txt

./../../../u/cgi_web/Tuition/cost <test_files/test_file_15.txt >temp
cmp -s temp gold_files/gold_file_15.txt
if [ $? -eq 0 ];
then
	echo "Test Run #15 has passed." >> output.txt

else
	echo "Test Run #15 has failed." >> output.txt

	echo "Expected:" >> output.txt

	cat gold_files/gold_file_15.txt >> output.txt

	echo "Result:" >> output.txt

	cat temp >> output.txt

fi
echo "Test Run #16" >> output.txt

./../../../u/cgi_web/Tuition/cost <test_files/test_file_16.txt >temp
cmp -s temp gold_files/gold_file_16.txt
if [ $? -eq 0 ];
then
	echo "Test Run #16 has passed." >> output.txt

else
	echo "Test Run #16 has failed." >> output.txt

	echo "Expected:" >> output.txt

	cat gold_files/gold_file_16.txt >> output.txt

	echo "Result:" >> output.txt

	cat temp >> output.txt

fi
echo "Test Run #17" >> output.txt

./../../../u/cgi_web/Tuition/cost <test_files/test_file_17.txt >temp
cmp -s temp gold_files/gold_file_17.txt
if [ $? -eq 0 ];
then
	echo "Test Run #17 has passed." >> output.txt

else
	echo "Test Run #17 has failed." >> output.txt

	echo "Expected:" >> output.txt

	cat gold_files/gold_file_17.txt >> output.txt

	echo "Result:" >> output.txt

	cat temp >> output.txt

fi
echo "Test Run #18" >> output.txt

./../../../u/cgi_web/Tuition/cost <test_files/test_file_18.txt >temp
cmp -s temp gold_files/gold_file_18.txt
if [ $? -eq 0 ];
then
	echo "Test Run #18 has passed." >> output.txt

else
	echo "Test Run #18 has failed." >> output.txt

	echo "Expected:" >> output.txt

	cat gold_files/gold_file_18.txt >> output.txt

	echo "Result:" >> output.txt

	cat temp >> output.txt

fi
echo "Test Run #19" >> output.txt

./../../../u/cgi_web/Tuition/cost <test_files/test_file_19.txt >temp
cmp -s temp gold_files/gold_file_19.txt
if [ $? -eq 0 ];
then
	echo "Test Run #19 has passed." >> output.txt

else
	echo "Test Run #19 has failed." >> output.txt

	echo "Expected:" >> output.txt

	cat gold_files/gold_file_19.txt >> output.txt

	echo "Result:" >> output.txt

	cat temp >> output.txt

fi
echo "Test Run #20" >> output.txt

./../../../u/cgi_web/Tuition/cost <test_files/test_file_20.txt >temp
cmp -s temp gold_files/gold_file_20.txt
if [ $? -eq 0 ];
then
	echo "Test Run #20 has passed." >> output.txt

else
	echo "Test Run #20 has failed." >> output.txt

	echo "Expected:" >> output.txt

	cat gold_files/gold_file_20.txt >> output.txt

	echo "Result:" >> output.txt

	cat temp >> output.txt

fi
echo "Test Run #21" >> output.txt

./../../../u/cgi_web/Tuition/cost <test_files/test_file_21.txt >temp
cmp -s temp gold_files/gold_file_21.txt
if [ $? -eq 0 ];
then
	echo "Test Run #21 has passed." >> output.txt

else
	echo "Test Run #21 has failed." >> output.txt

	echo "Expected:" >> output.txt

	cat gold_files/gold_file_21.txt >> output.txt

	echo "Result:" >> output.txt

	cat temp >> output.txt

fi
echo "Test Run #22" >> output.txt

./../../../u/cgi_web/Tuition/cost <test_files/test_file_22.txt >temp
cmp -s temp gold_files/gold_file_22.txt
if [ $? -eq 0 ];
then
	echo "Test Run #22 has passed." >> output.txt

else
	echo "Test Run #22 has failed." >> output.txt

	echo "Expected:" >> output.txt

	cat gold_files/gold_file_22.txt >> output.txt

	echo "Result:" >> output.txt

	cat temp >> output.txt

fi
echo "Test Run #23" >> output.txt

./../../../u/cgi_web/Tuition/cost <test_files/test_file_23.txt >temp
cmp -s temp gold_files/gold_file_23.txt
if [ $? -eq 0 ];
then
	echo "Test Run #23 has passed." >> output.txt

else
	echo "Test Run #23 has failed." >> output.txt

	echo "Expected:" >> output.txt

	cat gold_files/gold_file_23.txt >> output.txt

	echo "Result:" >> output.txt

	cat temp >> output.txt

fi
echo "Test Run #24" >> output.txt

./../../../u/cgi_web/Tuition/cost <test_files/test_file_24.txt >temp
cmp -s temp gold_files/gold_file_24.txt
if [ $? -eq 0 ];
then
	echo "Test Run #24 has passed." >> output.txt

else
	echo "Test Run #24 has failed." >> output.txt

	echo "Expected:" >> output.txt

	cat gold_files/gold_file_24.txt >> output.txt

	echo "Result:" >> output.txt

	cat temp >> output.txt

fi
echo "Test Run #25" >> output.txt

./../../../u/cgi_web/Tuition/cost <test_files/test_file_25.txt >temp
cmp -s temp gold_files/gold_file_25.txt
if [ $? -eq 0 ];
then
	echo "Test Run #25 has passed." >> output.txt

else
	echo "Test Run #25 has failed." >> output.txt

	echo "Expected:" >> output.txt

	cat gold_files/gold_file_25.txt >> output.txt

	echo "Result:" >> output.txt

	cat temp >> output.txt

fi
