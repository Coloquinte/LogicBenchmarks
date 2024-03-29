#!/bin/bash
# Original script to get and extract the benchmarks

rm -rf tmp
mkdir tmp
cd tmp

mkdir -p benchmarks/bench
mkdir -p benchmarks/blif

cd benchmarks

# Download ISCAS
cd bench
for bench in iscas85 iscas89 iscas99
do
	mkdir tmp
	cd tmp
	wget "https://pld.ttu.ee/~maksim/benchmarks/${bench}/bench" -qN -l1 -nH -np -r --cut-dirs=4 --reject="*.html*" --reject=robots.txt
	rm bench
	cd ..
	for i in $(ls tmp)
	do
		mv "tmp/${i}" "${bench}-${i}"
	done
	rm -rf tmp
done
cd ..

# Convert ISCAS
cd blif
for bench in $(ls ../bench)
do
	yosys-abc -c "read_bench ../bench/${bench}; write_blif ${bench%%.bench}.blif" > /dev/null
	sed -i "s/new_//g" "${bench%%.bench}.blif"
done
rm abc.history
cd ..

cd ..

# Download MCNC
wget https://ddd.fit.cvut.cz/www/prj/Benchmarks/MCNC.7z
7z x MCNC.7z

for directory in Combinational/blif Sequential/Blif
do
	for i in $(ls "MCNC/${directory}")
	do
		# Remove lines after .exdc: external don't care are not supported by Yosys
		sed -i '/^.exdc/,/^.end/{/^.end/!d;}' "MCNC/${directory}/${i}"
		# Add .end line if it is missing
		grep -q .end "MCNC/${directory}/${i}" || printf "\n.end" >> "MCNC/${directory}/${i}"
		cp "MCNC/${directory}/${i}" "benchmarks/blif/mcnc-${i}"
	done
done

# Download LGSynth
wget https://ddd.fit.cvut.cz/www/prj/Benchmarks/LGSynth91.7z
7z x LGSynth91.7z
for i in $(ls LGSynth91/blif)
do
	# Remove invalid lines from the files
	sed "/.wire_load_slope/d" -i "LGSynth91/blif/${i}"
	# Add .end line if it is missing
	grep -q .end "LGSynth91/blif/${i}" || printf "\n.end" >> "LGSynth91/blif/${i}"
	cp "LGSynth91/blif/${i}" "benchmarks/blif/lgsynth91-${i}"
done

# Download EPFL
wget https://github.com/lsils/benchmarks/archive/refs/tags/v2023.1.tar.gz
tar -xzf v2023.1.tar.gz
for i in benchmarks-2023.1/{arithmetic,random_control}/*.blif
do
        name=$(basename "${i}" .blif)
        cp "${i}" "benchmarks/blif/epfl-${name}.blif"
done

cd ..
mv tmp/benchmarks .
