#!/bin/zsh
#
# FileName: 	raw2format
# CreatedDate:  2022-07-10 20:52:42 +0900
# LastModified: 2022-07-11 00:09:33 +0900
#

_usage(){
    echo "Usage: $0 -i raw_file -o format_file"
    exit 1
}

while getopts :i:o:m: OPT
do
    case $OPT in
        i) raw_file=$OPTARG;;
        o) format_file=$OPTARG;;
        m) month=$OPTARG;;
        :|\?) _usage;;
    esac
done

base_raw="../datas/raw"
base_format="../datas/format"

if [[ -e $base_format/$format_file ]]
then
    rm $base_format/$format_file
fi

cat "$base_raw/$raw_file" | awk -F '[\t]' -v month=$month '
BEGIN {
    i=0
    line=""
}
{
    if (substr($1, 0, 2) == month){
        print line
        line=$1 "\t"
    }
    else{
        if (NF == 1){
            line=line $1 "\t"
        }
        else{
            line=line $0
        }
    }
}
END {
    OFS="-"
}
' > $base_format/$format_file
nkf -s --overwrite $base_format/$format_file
return
