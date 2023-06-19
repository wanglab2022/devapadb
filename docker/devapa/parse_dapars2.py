#!/usr/bin/env python

import click
import pandas as pd
import re
import os


@click.command()
@click.option("--dirin", '-i', default = ".", help="input directory name")
@click.option("--fout", '-o', default='dapars2_result.tsv', help="output file name")
def main(dirin, fout):
    # list all directories in current directory
    dapars2_dirs = [entry for entry in os.listdir(dirin) if os.path.isdir(entry) and entry.startswith("Dapars2_out_")]

    dfs = []
    for dapars2_dir in dapars2_dirs:
        chrid = dapars2_dir.replace("Dapars2_out_", "")
        dapars2_rst = os.path.join(dirin, dapars2_dir, "Dapars2_result_temp." + chrid + ".txt")
        df = pd.read_csv(dapars2_rst, sep="\t")
        # replace "/.*/" in column names
        df.columns = [re.sub("/.*/", "", x) for x in df.columns]
        # add a column "chromosome" and fill it with chrid, then move it to the first column
        df.insert(0, "chromosome", chrid)
        dfs.append(df)

    # concatenate all dataframes
    rst = pd.concat(dfs, ignore_index=True)
    rst.to_csv(fout, sep="\t", index=False)


if __name__ == '__main__':
    main()
