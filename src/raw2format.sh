#!/bin/zsh
#
# FileName: 	raw2format
# CreatedDate:  2022-07-10 20:52:42 +0900
# LastModified: 2022-07-11 18:00:30 +0900
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
base_format="../datas/format/${raw_file}"

mkdir -p ${base_format}
if [[ -e ${base_format}/${format_file} ]]
then
    rm ${base_format}/${format_file}
fi

echo "date\tstore\tspent\tvia\tmain\tsub" > ${base_format}/${format_file}
cat "${base_raw}/${raw_file}" | awk -F '[\t]' -v month=${month} '
BEGIN {
    i=0
    line=""
}
substr($1, 0, 2) == month{
    print line
    line=$1 "\t"
}
substr($1, 0, 2) != month{
    if (NF == 1){
        if ($1 ~ /[^a-zA-Z]/){
            gsub(",", "", $1)
        }
        line=line $1 "\t"
    }
    else{
        line=line $0
    }
}

' >> ${base_format}/${format_file}
#nkf -s --overwrite $base_format/$format_file
nkf -w8 --overwrite ${base_format}/${format_file}
return
