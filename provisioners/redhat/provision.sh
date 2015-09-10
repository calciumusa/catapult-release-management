#!/usr/bin/env bash



# variables inbound from provisioner args
# $1 => environment
# $2 => repository
# $3 => gpg key
# $4 => instance



echo -e "\n\n"
echo "                   mdQQQb                       "
echo "                ---- 4SSEO                      "
echo "                \    \SSQ'                      "
echo "                 \ \Y \Sp                       "
echo "                  \;\\\\_\                        "
echo "                .;'  \\\\                         "
echo "              .;'     \\\\                        "
echo "            .;'        \\\\                       "
echo "    ____  .;'____       \\\\   ____     ____      "
echo "   / / _\_L / /  \ ______\\\\_/_/__\__ / /  \     "
echo "  | | |____| | ++ |_________________| | ++ |    "
echo "   \_\__/   \_\__/          \_\__/   \_\__/     "
echo -e "\n\n"


echo -e "==> Receiving your Catapult Instance"

# install git
sudo yum install -y git

# clone and pull catapult
if ([ $1 = "dev" ] || [ $1 = "test" ]); then
    branch="develop"
elif ([ $1 = "qc" ]); then
    branch="release"
elif ([ $1 = "production" ]); then
    branch="master"
fi
if [ $1 != "dev" ]; then
    if [ -d "/catapult/.git" ]; then
        cd /catapult && sudo git checkout ${branch}
        cd /catapult && sudo git pull
    else
        sudo git clone --recursive -b ${branch} $2 /catapult | sed "s/^/\t/"
    fi
else
    if ! [ -e "/catapult/secrets/configuration.yml.gpg" ]; then
        echo -e "Cannot read from /catapult/secrets/configuration.yml.gpg, please vagrant reload the virtual machine."
        exit 1
    else
        echo -e "Your Catapult instance is being synced from your host machine."
    fi
fi

# kick off instance provisioner
if [ "${4}" = "apache" ]; then
    bash /catapult/provisioners/redhat/apache.sh $1 $2 $3 $4 | tee -a /catapult/provisioners/redhat/logs/apache.log
elif [ "${4}" = "mysql" ]; then
    bash /catapult/provisioners/redhat/mysql.sh $1 $2 $3 $4 | tee -a /catapult/provisioners/redhat/logs/mysql.log
else
    "Error: Cannot detect the instance type."
    exit 1
fi
