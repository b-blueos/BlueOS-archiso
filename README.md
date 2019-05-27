# BlueOS
This is a learning expierience for me...

You don't need to bother at all...

Use if you wish.

[BlueOS WebPage](https://blueos.burnyllama.tk)

# Compilation:
Currently there is no way to download BlueOS, but you can compile it yourself.

1. Install archiso 
```
sudo pacman -S archiso
```

2. Copy over the 'releng' folder to a working-directory.
```
mkdir work
cd work
sudo cp -r /usr/share/archiso/configs/releng/* ./
```

3. Copy over my files in this repo straight over to your work-dir.

4. Run the `build.sh`...
```
sudo bash build.sh -v
```

5. You will get an .iso in the `out`-directory.... Flash that on a USB and you are good to go.
