--Koku, convert and transfer your money--


Find the project directory of /Koku and run terminal at that respository. Run:
```
pod install

```

Do the same with directory path /UpdateActivity

Next, setub library and config a localhost.

1.Install Home brew. Open terminal and paste that
```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

```

2. Then using Brew to install NPM. 

```
brew install npm

```

3. Continue install json - server by npm:
```
npm install -g json-server

```

and socket.io 
```
npm install socket.io

```

4. Open directory path /server in terminal, then run 
```
npm install json-server --save-dev

```

5. run json-server --watch db.json to set DB file for localhost.
```
json-server --watch db.json

```


Then run server.js file.
```
node server.js

```

We have localhost with port 3000: http://localhost:3000, which support mocked API. Now we can start to using application.
