consolidate1 = "$baseDir/publish/consolidate1.txt"
file(consolidate1).delete()

Channel
	.fromPath("$baseDir/source/file*.txt")
	.splitText(by: 1)
	.set{lines}

process transform {
	input:
		val x from lines
	output:
		stdout into reverse 
	when:
		x =~ /.*=.*/ 
	script:
		"""
		echo -n '$x' 
		"""
}


reverse.collectFile(consolidate1)


// process transformAgain {
// 	input:
// 		val x from reverse 
// 	output:
// 		stdout into to_gather
// 	shell:
// 		"""
// 		echo -n '!{x}' | rev 
// 		"""
// }


// process gather1 {
// 	echo true

// 	input:
// 		val x from reverse.collect()
//  	exec:
// 		new File(consolidate1).setText(x.toString())
// }

