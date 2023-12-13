#!/usr/bin/env python3
"""convert reference seq ID to chr ID for ROSE"""

import argparse
import os
import sys
import csv

# --------------------------------------------------
def get_args():
	"""get args"""
	parser = argparse.ArgumentParser(description='seq ID to chr ID')
	parser.add_argument('-i', '--infile', help='old bed fie',
						type=str, metavar='FILE', required=True)
	parser.add_argument('-t', '--old_new', help='file with old and new name',
						type=str, metavar='FILE', required=True)	
	parser.add_argument('-o', '--outfile', help='output file',
						type=str, metavar='FILE', required=True)
	return parser.parse_args()

# --------------------------------------------------
def main():
	"""main"""
	args = get_args()
	infile = args.infile
	trans = args.old_new
	out_file = open(args.outfile,'w')
	
	h={}
	with open(trans,'r') as ref_h:
		reader = csv.reader(ref_h,delimiter='\t')
		for row in reader:
			h[row[0]] = row[1]

	with open(infile, 'r') as in_f:
		reader = csv.reader(in_f, delimiter='\t')
		for row in reader:
			print('{}\t{}'.format(h[row[0]],'\t'.join(row[1:])),file=out_file)
	

# --------------------------------------------------
if __name__ == '__main__':
	main()
