function display_usages {
        echo "Usages: ./backup.sh <path to your source> <path to backiup folder>"
}
if [ $# -eq 0 ]; then
        display_usages
fi

source_dir=$1;
timestamp=$(date "+%Y-%m-%d-%H-%M-%S")
backup_dir=$2;

function create_backup {
        zip -r "${backup_dir}/backup_${timestamp}.zip" "${source_dir}" >/dev/null
        if [ $? -eq 0 ]; then
                echo "backup generated successfully for ${timestamp}"
        fi
}
function perform_rotation {
        backups=( $(ls -t "${backup_dir}/backup_"*.zip 2>/dev/null ))
        if [ "${#backups[@]}" -gt 7 ]; then
                backups_to_remove=( "${backups[@]:7}" )
                for backup in "${backups_to_remove[@]}";
                do
                        rm -f "$backup"
                done
        fi
}
create_backup
perform_rotation
