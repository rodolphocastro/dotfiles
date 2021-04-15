echo "Starting up dotfiles bootstrap (nix flavored)"
echo "This script will override some of your home files"
echo "If you are okay with that complete the sentence below, ALL CAPS please..."
read -p "LEEEEEEEROY " answer
if [ $answer != "JENKINS" ]
then
    echo "At least you have chicken 🐔"
    return -1
fi

# user's .gitconfig
echo "Setting up .gitconfig"
ln -f ./.gitconfig ~/.gitconfig

# user's .gitignore
echo "Setting up .gitignore"
ln -f ./.gitignore ~/.gitignore

# user's .bashrc
echo "Setting up bashrc"
ln -f ./.bashrc ~/.bashrc

# extra steps!
echo "Bootstrap complete, if you see any bash errors remember that you might need to install extra dependencies"
echo "If this is within a WSL environment you might want to link up your SSH files and other goodies, use the script on bash/misc"

return 0
