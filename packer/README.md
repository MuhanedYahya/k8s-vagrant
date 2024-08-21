# build custom vagrant image 
```
packer init packer.pkr.hcl
```
```
packer build packer.pkr.hcl
```

after the box generation

```
vagrant box add ANY_NAME output-box/package.box
```