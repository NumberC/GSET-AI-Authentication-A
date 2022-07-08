#!/bin/bash

# _([0-9]*)k?hzto([0-9]*)k?hz_([0-9]*)k?hzfs_([[0-9]*)ms_[0-9]*ms_Repeat([0-9]*)

for PERSON in recordings/*; do
	echo $PERSON;

	mkdir $PERSON/left
	mkdir $PERSON/right

	for FILE in transmissions/*; do
		mkdir $PERSON/left/${FILE:14:-4};
		mkdir $PERSON/right/${FILE:14:-4};
	done
done
