#!/bin/sh

install_location="$HOME/.opt"


help() {
    program="$(basename "$0")"
    echo "Usage: $program [OPTION] FILE"
    echo "  $program file.tar                      Install the tar program in $install_location"
    echo "  $program -u, --uninstall file.tar      Uninstall the tar file already installed"
    echo ""
    echo "ATENTION: BE SURE THAT YOUR TARBALL HAS THE FOLLOWING FORMAT:"
    echo "  /program_name"
    echo "      /bin"
    echo "          program"
    echo "      /lib"
    echo "          ..."
    echo "      /share"
    echo "          ..."
}

uninstall() {
    file=$1

    if [ -z "$file" ]; then
        printf "File was not provided.\n\n"
        help
        exit 1
    fi

    echo "UNINSTALLING $file"

    # Get files to remove
    printf "\nListing files for removal in %s\n\n" "$file"
    echo "+ tar -tf $file | cut -d'/' -f 2-"
    files_and_folders_to_remove="$(tar -tf "$file" | cut -d'/' -f 2-)"
    exit_code="$?"

    if [ "$exit_code" -ne 0 ]; then
        printf "\nError listing files in %s\n" "$file"
        exit "$exit_code";
    fi

    files_to_remove="$(echo "$files_and_folders_to_remove" | awk -F'/' '{if ($NF != "") print $0}')"
    folders_to_remove="$(echo "$files_and_folders_to_remove" | awk -F'/' '{if ($NF == "") print $0}' | tac)"

    # Remove files
    printf "\nRemoving files\n\n"
    echo "+ echo \$files_to_remove | xargs -I'{}' rm -r $install_location/{}"
    echo "$files_to_remove" | xargs -I'{}' rm "$install_location"/{}
    exit_code="$?"

    if [ "$exit_code" -ne 0 ]; then
        printf "\nError removing files in %s\n" "$install_location"
        exit "$exit_code";
    fi

    printf "\nRemoving empty folders\n\n"
    echo "+ echo \$folders_to_remove | xargs -I'{}' rm -d $install_location/{}"
    echo "$folders_to_remove" | xargs -I'{}' rm -d "$install_location"/{}

    printf "\nSuccessefully uninstalled %s\n" "$file"
}


install() {
    file=$1

    if [ -z "$file" ]; then
        printf "File was not provided.\n\n"
        help
        exit 1
    fi

    echo "INSTALLING $file"

    tmp_location="${install_location}/tmp"
    mkdir "$tmp_location"

    # Extract the archive
    printf "\nExtracting %s to %s\n\n" "$file" "$tmp_location"
    echo "+ tar -xvf $file -C $tmp_location"
    tar -xvf "$file" -C "$tmp_location"
    exit_code="$?"

    if [ "$exit_code" -ne 0 ]; then
        printf "\nError extracting %s\n" "$file"
        exit "$exit_code";
    fi

    extracted_to="$tmp_location/$(tar -tf "$file" | cut -d'/' -f1 | head -n1)"
 
    # Install to $install_location
    printf "\nInstalling %s\n\n" "$file"

    echo "+ find $extracted_to -maxdepth 1 | awk -F '/' '(NR> 1) {print $NF}' | xargs -I'{}' mv $extracted_to/{} $install_location/{}"
    find "$extracted_to" -maxdepth 1 | awk -F '/' '(NR> 1) {print $NF}' | xargs -I'{}' cp -r "$extracted_to"/{} "$install_location"/
    exit_code="$?"

    if [ "$exit_code" -ne 0 ]; then
        printf "\nError installing %s into %s\n" "$extracted_to" "$install_location"
        exit "$exit_code";
    fi

    rm -rf "$tmp_location"

    printf "\nSuccessefully installed %s\n" "$file"
}

arg="${1}"
case ${arg} in
    "-h"|"help")
        help;;
    "-u"|"uninstall")
        uninstall "$2";;
    *)
        install "$1";;
esac

