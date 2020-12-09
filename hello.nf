consolidate1 = "$baseDir/publish/consolidate1.txt"
file(consolidate1).delete()

Channel
	.fromPath("$baseDir/source/file*.txt")
	.splitText(by: 1)
	.set{lines}

process showImplicit {

	cache false
	time '1s'
	maxForks 1

	beforeScript 'echo beforetransform'
	afterScript 'echo aftertransform'

	output:
		stdout into implicit 
	script:
	println ""
	println "showImplicit"
	println task.cpus
	println baseDir
	println launchDir
	println projectDir
	println nextflow
	println params
	println ""
	"""
	exit
	"""
}

process transform {
	input:
		val x from lines
	output:
		stdout into reverse 
	when:
		x =~ /.*=.*/ 
	script:
		"""
		echo -n '$x' | rev 
		"""
}


process transformAgain {
	input:
		val x from reverse 
	output:
		stdout into to_gather
	shell:
		"""
		echo -n '!{x}' | rev 
		"""
}


process gather {

	// publishDir "$launchDir", mode: 'copy', overwrite: true
	// beforeScript "rm $launchDir/publish/consolidate1.txt"
	maxForks 0
	input:
		val x from to_gather.collectFile(name: consolidate1, newLine: false)
	exec:
		// to_gather.collectFile(name: consolidate1, newLine: false)
		println x
		// to_gather.close()
		//file(consolidate1).append(x)
}



