### README

This is a super simple Ruby on Rails app that generates an html page from file.
I'm currently using this to generate my resume on ccrockett.com

I created this app as I was continually having to update multiple files. This app allows me to just update my json file and then output it in HTML and PDF

### How To Use:

* Clone repo
* Bundle install
* create resume.json in root folder (see JSON Example below)
* rails server


### File format

* JSON
```
{
	"name": {
		"value": <string>
	},
	"address1": {
		"value": <string>
	},
	"phone": {
		"desc": <string>,
		"value": <string>
	},
	"email":{
		"desc":<string>,
		"value": <string>
	},
	"website": {
		"desc": <string>,
		"value": <string>,
		"link": <string>
	},
	"summary": {
		"title":<string>,
		"content": <string>
	},
	"skills": { 
		"title":<string>,
		"content": <string>
	},
	"experience" : [
	{
		"dates": <string>,
		"title": <string>,
		"company": <string>,
		"location": <string>,
		"extra": <string>,
		"responsibilities": [
			<string>,<string>,<string>
		]
	},
	"education":[{
		"name":<string>,
		"grad_date":<string>,
		"degree":<string>
	}]
}
```

### Requirements

This was only tested on Rails 5.1.4 and Ruby 2.4.x


### To Do:

* add an xml parser class
* move PDF render to more template based
* add i18n for any static strings
* add config page for settings like pdf file name, json file location, etc.

