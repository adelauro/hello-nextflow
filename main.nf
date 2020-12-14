gen = Channel.from(1..10)


process transform1 {
        container 'ubuntu:latest'
	input:
		val x from gen 
	output:
		path '1byte.txt' into transformed1
	shell:
		"""
		echo -n X > 1byte.txt
		"""
}

transformed1.into{consolidate1; twotransform}

consolidate1.collectFile(name: "consolidate1.txt",  newLine: false)

