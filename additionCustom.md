-added new flag -ep (endpoint) which can add sub.domain.tld requested endpoint for direct endpoint targeting. 

-usage examples:
subfinder -d google.com -all | httpxc -sc -ct -cl -td -location -title -ip -ep /logs
cat subList.txt | httpxc -sc -ct -cl -td -location -title -ip -ep /logs
httpxc -dL subList.txt -sc -ct -cl -td -location -title -ip -ep /logs

-installation: 
GOPROXY=direct go install -v github.com/pelamx/httpxCustom/cmd/httpxc@dev
