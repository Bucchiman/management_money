#!/bin/zsh
#
# FileName: 	raw2format
# CreatedDate:  2022-07-10 20:52:42 +0900
# LastModified: 2022-07-10 23:00:54 +0900
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
        if (line ~ /, $/){
            printf "%s\n", substr(line, 0, length(line)-2)
        }
        line=$1 ", "
    }
    else{
        if (NF == 1){
            line=line $1 ", "
        }
        else{
            for(i=1; i<NF; i++){
                line=line $i ", "
            }
            line=line $NF

        }
    }
}' > $base_format/$format_file
nkf -s --overwrite $base_format/$format_file
return
