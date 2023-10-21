#!/bin/sh

accounts_file=$1

# Check if file path was provided
if [ -z "$accounts_file" ]; then
    echo "File not provided."
    exit 1
fi

printf "Password: "
stty -echo
read -r password
stty echo
printf "\n"

# Decrypt the andotp generated file
accounts_json=$(go-andotp -d -i "$accounts_file" -p "$password")
if [ "$(echo $accounts_json | awk '{print $1;}')" = "error:" ]; then
    echo "Could not decrypt the file"
    exit 1;
fi

# Get Issuers
issuers=$(echo "$accounts_json" | jq -r '.[] | .issuer')
issuers_count=$(echo "$accounts_json" | jq -r '. | length')

# Get issuer
printf "\nWhat issuer do you want?\n" "$issuers"

# Print issuers with index as prefix
for i in $(seq 1 "$issuers_count"); do
    issuer=$(echo "$issuers" | awk "NR==$i")
    echo "$i: $issuer"
done

printf "\nIssuer index: "
read -r issuer_i

# Check valid input (needs to be a number and less or equal to issuers_count)
if ! ([ "$issuer_i" -eq "$issuer_i" ] && [ "$issuer_i" -le "$issuers_count" ] && [ "$issuer_i" -ge "1" ]); then
    echo "Invalid index!"
    exit 1;
fi

issuer_selected=$(echo "$issuers" | awk "NR==$issuer_i")

# Get secret
secret=$(echo "$accounts_json" | jq -r ".[] | select(.issuer == \"$issuer_selected\") | .secret")

# Get otp-code
code=$(echo "$secret" | xargs oathtool --totp -b)
echo "\nOTP CODE: $code"
