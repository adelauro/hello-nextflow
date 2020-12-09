nextflow.enable.dsl=2
process showImplicit {

	cache false
	time '1s'
	maxForks 1

	beforeScript 'echo beforetransform'
	afterScript 'echo aftertransform'

	exec:
	println ""
	println "showImplicit"
	println task.cpus
	println baseDir
	println launchDir
	println projectDir
	println nextflow
	println params
	println ""
}

process transform {
	input:
		val x 
	output:
		stdout 
	when:
		x =~ /.*=.*/ 
	script:
		"""
		echo -n '$x' | rev 
		"""
}


process transformAgain {
	input:
		val x 
	output:
		stdout
	shell:
		"""
		echo -n '!{x}' | rev 
		"""
}

process gather {
	input:
		val x 
	exec:
		file(consolidate1).append(x)
}

process takeHalf {
	input:
		val x
	exec:


}


consolidate1 = "$baseDir/publish/consolidate1.txt"

workflow flow1 {
	main:
		showImplicit()
		file(consolidate1).delete()
		Channel
			.fromPath("$baseDir/source/file*.txt")
			.splitText(by: 1)
			.set{lines}
		transform(lines) | (gather & transformAgain) 
	emit:
		// transformAgain.out.multiMap { it -> 
		// 	one: it	
		// 	two: it
		// }.set { forked }
		// half = forked.one.count() / 2
}

workflow flow2 {
	take:
		data
	main:
		showImplicit()
		takeHalf(data)
}

workflow {
	main:
		flow1()
		flow2(flow1.out)
}


