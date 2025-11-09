added new flag -ep (endpoint) which can add sub.domain.tld requested endpoint for direct endpoint targeting. 

usage examples:
```bash
subfinder -d google.com -all | httpxc -sc -ct -cl -td -location -title -ip -ep /logs
cat subList.txt | httpxc -sc -ct -cl -td -location -title -ip -ep /logs
httpxc -dL subList.txt -sc -ct -cl -td -location -title -ip -ep /logs
```
installation: 
GOPROXY=direct go install -v github.com/pelamx/httpxCustom/cmd/httpxc@dev

Alternative Installation (if above doesn't work):
```bash
git clone https://github.com/pelamx/httpxCustom
cd httpxCustom/cmd/httpxc
go build
sudo mv httpxc /usr/local/bin/
```
