#! /bin/bash
for i in {0..48}
do
	cp badsample${i}out.txt sample${i}idea.txt
	rm badsample${i}out.txt
done
