#!/bin/zsh
#
# FileName: 	format2kindformat
# CreatedDate:  2022-07-11 18:02:50 +0900
# LastModified: 2022-07-11 21:18:17 +0900
#

_usage(){
    echo "Usage: $0 -f object_file"
    exit 1
}

while getopts :n:m:k: OPT
do
    case $OPT in
        n) format_name=$OPTARG;;
        k) kind=$OPTARG;;
        :|\?) _usage;;
    esac
done

csv_name=${format_name}".csv"
output_csv_name=${format_name}"_"${kind}".csv"
base_dir="../datas/format/"${format_name}

if [[ -e ${base_dir}/${output_csv_name} ]]
then
    rm ${base_dir}/${output_csv_name}
fi

cat ${base_dir}/${csv_name} | awk -v kind=${kind} '
BEGIN{
}
NR==1{
    print $0;
}
{
    if ($5 ~ /["'${kind}'"]/){
        print $0;
    }
}
' >> ${base_dir}/${output_csv_name}
#nkf -s --overwrite $base_format/$format_file
nkf -w8 --overwrite ${base_dir}/${output_csv_name}



return
