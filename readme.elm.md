# Spring Petclinic Sample Application - with an elm frontend

Currently there is no integrated build for both parts!  
You'll first have to build the base spring-petclinic with the standard maven means.

After a successful maven build you have to build the elm part as follows:

``elm make src/main/elm/Main.elm --output target/classes/static/elm/elm.js``

You can start the application (from its root-directory) like this: ``./mvnw spring-boot:run``  

With the started application, you'll get the original UI via [http://localhost:8080/]().  
You'll get the elm UI via [http://localhost:8080/elm/index.html]().
