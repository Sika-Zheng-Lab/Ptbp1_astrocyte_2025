import os
import sys

# Paths
snakefile_path = os.path.abspath(__file__)
parentdir = os.path.dirname(os.path.dirname(workflow.snakefile))

# Example event/group/region definitions
# events_list = ["SE", "FIVE", "THREE", "MXE", "RI", "MSE", "AFE", "ALE"]
events_list = ["SE"]
groups_list = ["all", "diff"]
regions_dict = {
    "SE": [
        "intron_upstream_donor",
        "intron_upstream_acceptor",
        "exon_upstream",
        "exon_downstream",
        "intron_downstream_donor",
        "intron_downstream_acceptor"
    ]
}

# Create a flattened list of (event, group, region) combinations
# so we can easily expand them.
# Since we only have ["SE"], this is straightforward; if you add
# more events, this still works properly.
combinations = []
for evt in events_list:
    for grp in groups_list:
        for reg in regions_dict[evt]:
            combinations.append((evt, grp, reg))

# Also collect (event, region) pairs for final XSTREME.
evt_region_pairs = []
for evt in events_list:
    for reg in regions_dict[evt]:
        evt_region_pairs.append((evt, reg))

# Load config
workdir: config["workdir"]

################################################################################
# 1) rule all
#
# Ensure the final target is to create all xstreme.html files for every
# (event, region) combination.
################################################################################
rule all:
    input:
        expand(
            "xstreme/{event}_{region}/xstreme.html",
            event=[evt for (evt, _) in evt_region_pairs],
            region=[reg for (_, reg) in evt_region_pairs]
        )

################################################################################
# 2) rule shiba2bed
#
# This rule produces all bed files for all combinations from a single input.
# If your `shiba2bed.py` script *requires* one call per combination, you would
# instead define a separate rule with wildcards (see comment below). However,
# if it correctly produces *all* the needed BED files in one run, you can keep
# the expand(...) approach as below.
################################################################################
rule shiba2bed:
	container:
		"docker://naotokubota/shiba-suite:develop"
	input:
		config["shibadir"]
	output:
		expand(
			"bed/{event}/{group}_{region}.bed",
			zip,
			event=[evt for (evt, grp, reg) in combinations],
			group=[grp for (evt, grp, reg) in combinations],
			region=[reg for (evt, grp, reg) in combinations]
		)
	threads:
		1
	benchmark:
		"benchmark/shiba2bed.txt"
	log:
		"log/shiba2bed.log"
	shell:
		"""
		python {parentdir}/src/shiba2bed.py \
		-i {input} \
		-o bed \
		-e {config[exon_length]} \
		-n {config[intron_length]} \
		-v \
		>& {log}
		"""

################################################################################
# 3) rule fetch_sequences
#
# Similar to above, if `fetch_sequences.py` can fetch all sequences in one shot
# from all BED files, you can use expand in the input and output. If it must be
# called for each combination separately, you would define a wildcard-based rule.
################################################################################
rule fetch_sequences:
	container:
		"docker://naotokubota/shiba-suite:develop"
	input:
		expand(
			"bed/{event}/{group}_{region}.bed",
			zip,
			event=[evt for (evt, grp, reg) in combinations],
			group=[grp for (evt, grp, reg) in combinations],
			region=[reg for (evt, grp, reg) in combinations]
		)
	output:
		expand(
			"fasta/{event}/{group}_{region}.fa",
			zip,
			event=[evt for (evt, grp, reg) in combinations],
			group=[grp for (evt, grp, reg) in combinations],
			region=[reg for (evt, grp, reg) in combinations]
		)
	threads:
		1
	benchmark:
		"benchmark/fetch_sequences.txt"
	log:
		"log/fetch_sequences.log"
	shell:
		"""
		python {parentdir}/src/fetch_sequences.py \
		-i bed \
		-f {config[genome_fasta]} \
		-o fasta \
		--rna \
		-v \
		>& {log}
		"""

################################################################################
# 4) Per-(event, region) rule for XSTREME
#
# We generate a separate named rule for each (event, region) combo. This is one
# of the standard “dynamic rule creation” patterns in Snakemake. Each gets a
# unique rule name like xstreme_SE_intron_upstream_donor, etc.
#
# Alternatively, you can define *one* rule with wildcards:
#
#     rule xstreme:
#         input:
#             fasta_target="fasta/{event}/diff_{region}.fa",
#             fasta_control="fasta/{event}/all_{region}.fa",
#             motifs=config["motifs"]
#         output:
#             "xstreme/{event}_{region}/xstreme.html"
#         ...
#
# …but below we keep your for-loop approach, just adjusted to proper syntax.
################################################################################
for evt, reg in evt_region_pairs:
	rule_name = f"xstreme_{evt}_{reg}"
	rule:
		# We give the rule a dynamic name by patching it after creation:
		# The 'name' attribute in Snakemake 5.x+ can work but is less typical.
		# It's simpler to define e.g. rule xstreme_{evt}_{reg}: in a single line,
		# but that means writing out the for-loop in pure Python. So here's an
		# equivalent approach:
		name:
			rule_name
		container:
			"docker://memesuite/memesuite:5.5.7"
		input:
			fasta_target = f"fasta/{evt}/diff_{reg}.fa",
			fasta_control = f"fasta/{evt}/all_{reg}.fa",
			motifs = config["motifs"]
		output:
			f"xstreme/{evt}_{reg}/xstreme.html"
		params:
			outdir = f"xstreme/{evt}_{reg}"
		threads:
			workflow.cores / 6
		benchmark:
			f"benchmark/xstreme_{evt}_{reg}.txt"
		log:
			f"log/xstreme_{evt}_{reg}.log"
		shell:
			"""
			xstreme \
			--p {input.fasta_target} \
			--n {input.fasta_control} \
			--oc {params.outdir} \
			--rna \
			--m {input.motifs} \
			--meme-p {threads} \
			>& {log}
			"""
