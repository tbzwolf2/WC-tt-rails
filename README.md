# WC-tt-rails
#### WC tech test of a rails app to pull api companies with simple front end 

## Fast start

1. Install docker desktop and git
2. Clone this repo locally
3. Navigate to your local repo from a terminal and simply `docker compose up` in your terminal 
4. Visit `localhost:3000` to see this one of a kind website!

## Development notes
 - Unfortunately, this project lacks a front end framework to make it look lovely, I only have a Windows machine to 
develop with and this seems to make building or using any framework tools a very difficult task while using [WSL](https://learn.microsoft.com/en-us/windows/wsl/install), that I've not been able 
to complete. Instead it has very simple CSS.
 - The main decision to make here as far as I could see was how to do subsequent api calls one for the initial api id and 
another for the details. I decided to use iframes to make this easy and fairly rails-ey, it's allowed me to not use any JS
and keep everything within the confines of the opinionated rails frame work. The biggest downside of this is cpu and load time,
accessing the front page is fairly fast but those with quick fingers will be able to see that the iframes are blank for
a moment before their calls to the api are complete. It's quite hidden but the biggest disadvantages of this are that 
the log file becomes close to unreadable with 30+ calls per load, and that this might not scale well in its current state 
if for example 100 companies were required on a single page (although I'm sure pagination would come before this).