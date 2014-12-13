#! /bin/bash
for i in {0..52}
do
	cp badsample${i}out.txt badsample${i}idea.txt
	rm badsample${i}out.txt
done

for i in {0..48}
do
	cp goodsample${i}out.txt goodsample${i}idea.txt
	rm goodsample${i}out.txt
done
