var express = require('express');
var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);
app.use(express.static('public'));
// io.serveClient( true ); // the server will serve the client js file

app.get('/', function(req, res){
	res.sendFile(__dirname + '/test.html');
});

// Creating a custom namespace
var customNsp = io.of('/customNamespace');

// Empty list of rooms.
var listOfRooms = [];
var listOfUsers = [];
// Creating the general room.
var generalRoom  = new RoomObject (
	"general",
	[[2, 1, 0, 0], 
		[0, 0, 0, 1], 
		[0, 0, 0, 0], 
		[0, 2, 1, 1]],
	"undefined",
	"undefined",
	[["Welcome to the general room!"]],
	[]
);
// Adding it to the list.
listOfRooms[0] = generalRoom;


// When someone connects to the custom namespace
customNsp.on('connection', function (socket) {

	// Getting the socket id
	var id = socket.id;
	// Automatically joining the general room on connnection.
	joinGeneralRoom(socket);

	console.log('connected socket is : ' + socket.id);

	// Get the updated status of the room list(prob also users and chat.)
	updatePage(socket);

	// Add to the list of connected users.

	socket.on('setNickname', function (nickname) {
		socket.nickname = nickname;
		console.log('user ' + socket.nickname + ' joined the custom namespace');
		listOfUsers.push(socket.nickname);
		console.log(listOfUsers);
		customNsp.emit('addUserToList', socket.nickname);
	});
	
	// Check for the existence of the room. If does not exist,
	// create a room object and add it to the list.
	// Then quit old room for the new one. 
	// Probably needs to get and send the room object somewhere.
	socket.on('joinRoom', function (roomName) {
		if (alreadyInRoom(socket, roomName)){
			console.log('already in room ' + roomName);
			return;
		} else if (roomExist(roomName)) {
			ifRoomExist(socket, roomName);
		} else {
			ifRoomDoesNotExist(socket, roomName);
		}
	});

	socket.on('message', function (room, msg) {
		customNsp.in(room).emit('messagePrint', msg);
		console.log('sending message to room: ' + room);
	});

	socket.on('leave', function () {
		leaveRoomButton(socket);
	});

	socket.on('showRooms', function () {
		console.log('list of all the rooms and who is inside.');
		console.log(customNsp.adapter.rooms);
	});
	socket.on('showRoomsIn', function () {
		// console.log('This socket is in the following rooms :');
		// console.log(socket.rooms);

		Object.keys(io.sockets.sockets).forEach(function(id) {
		    console.log("ID:",id)  // socketId
		})
	});

	// RANDOM COMMENT
	socket.on('Who', function (roomName) {
		if (roomName != 'no room'){
			console.log('User list from room object : ' + roomName);
			console.log(getRoomObject(roomName).users.nickname);
		}
	});
	socket.on('post chat', function (msg, roomName) {
		console.log('message is : ' + msg);
		getRoomObject(roomName).chat.push(msg);
		console.log(getRoomObject(roomName).chat);

		// As of now, treating general and other the same way. Check if it needs to be differenciated.
		if(roomName == 'general'){
			customNsp.to(roomName).emit('newChatLine', msg, roomName);
		} else {
			customNsp.to(roomName).emit('newChatLine', msg, roomName);
		}
		
	});

	socket.on('toConsole', function (msg) {
		console.log(msg);
	});
	socket.on('createRoom', function (newRoomName) {
		if (alreadyInRoom(socket, newRoomName)){
			console.log('already in room ' + newRoomName);
			return;
		} else if (roomExist(newRoomName)) {
			ifRoomExist(socket, newRoomName);
		} else {
			ifRoomDoesNotExist(socket, newRoomName);
		}
	});
	socket.on('openPrivateTab', function (userListNickname, nickname, privateRoomName) {
		if ( roomExist (privateRoomName) ) {
			ifPrivateRoomExist (socket, privateRoomName);
		} else {
			ifPrivateRoomDoesNotExist(socket, privateRoomName, userListNickname, nickname);
		}
	});

	socket.on('disconnect', function (){
		clearUsersListAfterDisconnect(socket);
		listOfUsers.splice(getUserIndex(socket.nickname), 1);
		customNsp.emit('removeUserFromList', socket.nickname);
	});


});












io.on('connection', function (socket){
	//console.log('user ' + socket.id + 'joined io');

	socket.emit('custom', 'Hi Bro normal');

	// This sends a message to the client
	socket.emit('greetings', 'Hello from the server!', socket.id);

	// Listen for the 'messageClient' event.
	socket.on('messageClient', function (msg) {
		console.log('User ' + this.id + ' sent message "' + msg + '"');
	});

	socket.on('tellEveryone', function (msg) {
		// Pass the socket.id so that others can know where it comes from.
		io.emit('heyEveryone', msg, socket.id); 

		// This io.emit is actually a helper function that gets the default
		// namespace (/) and calls emit() on that. The following 3 do the same:
		// io.emit('heyEveryone', msg, socket.id);
		// io.sockets.emit('heyEveryone', msg, socket.id); 
		// --> io.sockets is a reference to the main "/" namespace.
		// io.of('/').emit('heyEveryone', msg, socket.id);
		// --> of('/') is how we reference a namespace, in this case "/"
	});

	// Sockets in one namespace cannot send message to sockets in other namespaces.
	// You can work around that by using this:
	// socket.on('tellNamespace', function(msg, namespaceName){
	//	io.of(namespaceName).emit('heyEveryone', msg, socket.id); //NOTE: namespace will be created if nonexistent.
	//});


	// To send a message to a room, being part of it is not necessary but
	// to receive this room's message you need to have joined.
	socket.on('tellRoom', function (msg, roomName) {
		socket.to(roomName).emit('heyThere', msg, socket.id); //NOTE: room will be created if nonexistent.
		// in(roomName) also works instead of to(roomName).
		// it is possible to send to multiple rooms by chaining.
		// socket.to( room1Name ).to( room2Name ).emit( 'heyThere', msg, socket.id );
	});


	// Broadcast send to everyone but yourself.
	socket.on('broadcastMsg', function (msg) {
		socket.broadcast.emit( 'broadcastFrom', msg, socket.id );
	});

	// To send a message to another user there is two ways.
	// You can get the socket of the other user from the connected 
	// dictionary on our namespace and call emit() on it.
	// Or send a message to the room of this user.
	// When a socket connects, it automatically join a room with
	// the same name of its id. So you can send a message to that room
	socket.on('sendToUser', function (msg, userID) {
		// Try and get the socket from our connected list.
		var otherSocket = io.sockets.connected[userID]; //NOTE: sockets is the default "/" namespace.
		if ( otherSocket )
			otherSocket.emit(' messageFromUser', msg, socket.id);
	});

	// To send a list of all the socket IDs in a particular namespace, 
	// you can go through the connected dictionary on the namespace.
	//var sids = keys(io.sockets.connected);

	// For the IDs of a room, use the adapter property on the namespace.
	//var socketsInRoom = io.sockets.adapter.rooms[roomName];
	//var sids2 = (socketsInRoom) ? keys(socketsInRoom) : []



	// This execute when receive a message from the client. Here a 
	// disconnect signal
	socket.on('disconnect', function(){
		//console.log('user ' + socket.id + ' disconnected');
	});


});



// Set the port to listen to.
http.listen(3000, function(){
	console.log('listening on *:3000');
});


// When a new user joins, update the page with the rooms and users list.
// Also display the chat
function updatePage (socket) {
	console.log('entering updatePage with users : ' + listOfUsers);
	for( var i = 0; i < listOfRooms.length; i++){
		customNsp.to(socket.id).emit('addRoomToList', listOfRooms[i].name);
	}
	for( var i = 0; i < listOfUsers.length; i++){
		// For itself, skip. Broadcasted after getting the nickname in another method;
		if (socket.nickname == listOfUsers[i]){
			continue;
			//customNsp.emit(addUserToList, listOfUsers[i]);
		} else {
			customNsp.to(socket.id).emit('addUserToList', listOfUsers[i]);
		}
	}

	customNsp.emit('eraseAndPrintChat', 'general', getRoomObject('general').chat);

}

// Join the general room.
function joinGeneralRoom (socket) {
	socket.join('general');
	console.log('joined the general room');
	var generalRoomObject = listOfRooms[0];
	generalRoomObject.addUserToRoom(socket);

	//console.log('joinGeneralRoom OK');
}


// Check if the socket is already in a given room.
function alreadyInRoom (socket, room) {
	var roomsIn = socket.rooms;
	if (roomsIn) {
		for (var roomHere in roomsIn) {
			if (roomHere === room) {
				return true;
			}
		}
	}
	return false;
}

// Check the list of rooms for a room with the same name.
function roomExist (roomName) {
	for ( var i = 1; i < listOfRooms.length; i++){
		if (listOfRooms[i].name === roomName){
			return true;
		}
	}
	return false;
}

// Get the room object from the list and return it.
function getRoomObject (roomName) {
	//console.log('number of rooms = ' + listOfRooms.length);
	for ( var i = 0; i < listOfRooms.length; i++){
		if (listOfRooms[i].name === roomName){
			//console.log('Inside if : room object : ');
			//console.log(listOfRooms[i]);
			return listOfRooms[i];
		}
	}
}
// Get the actual index of the room and return it.
function getRoomIndex (roomName) {
	for ( var i = 0; i < listOfRooms.length; i++){
		//console.log('i is : ' + i + ' and listOfRooms[i].name is : ' + listOfRooms[i].name);
		if (listOfRooms[i].name == roomName){
			//console.log('returning i : ' + i);
			return i;
		}
	}
}
// Get the actual index of the user's nickname and return it.
function getUserIndex (userNickname) {
	for ( var i = 0; i < listOfUsers.length; i++){
		//console.log('i is : ' + i + ' and listOfUsers[i] is : ' + listOfUsers[i]);
		if (listOfUsers[i]== userNickname){
			//console.log('returning i : ' + i);
			return i;
		}
	}
}

// Return a new room object.
function createNewRoomObject (room, creatingUser) {
	var newRoom  = new RoomObject (
		room,
		[[2, 1, 0, 0], 
			[0, 0, 0, 1], 
			[0, 0, 0, 0], 
			[0, 2, 1, 1]],
		"undefined",
		"undefined",
		[["Welcome to room: " + room], ["Enjoy yourself"],
		["And don't worry, friends will come soon."]],
		[creatingUser]
	);
	return newRoom;
}

// Room object prototype.
function RoomObject (name, board, redP, blueP, chat, users) {
	this.name = name;
	this.board = board;
	this.redP = redP;
	this.blueP = blueP;
	this.chat = chat;
	this.users = users;
	this.addUserToRoom = function (joiningUser) {
		this.users.push(joiningUser);
	};
	this.removeUserFromRoom = function (leavingUser) {
		for (var i = 0; i < users.length; i++){
			//console.log('user : ' + users[i].nickname + ' in list');
			if (users[i] === leavingUser){
				var index = this.users.indexOf(users[i]);
				this.users.splice(index, 1);
				console.log('removed user : ' + leavingUser.nickname);
			}
		}
		// If the room is empty set it to empty. General room will never be set to empty.
		if (this.users.length === 0 && this.name != "general") {
			this.isEmpty = true;
		}
	};
	this.isEmpty = false;

}

// To receive and print the chat. Probably needs to emit there.
// Or just send the chat object to the client.
// Probably needs to recycle someway. And needs a db.
function printingChat (chat) {
	for (var i = 0; i < chat.length; i++) {
		console.log( (i + 1) + ' : ' + chat[i]);
	}
}


function joinRoom (socket, roomName) {
	socket.join(roomName);
	console.log('joining room :' + roomName);
}

// When receiving the socket from the on.disconnect method, the socket already left
// all the rooms. Need to clean up using the socket id instead.
function clearUsersListAfterDisconnect (socket){
	console.log('entering disconnected process');
	// Looping through the rooms and checking users. Removing disconnected user.
	for ( var i = 0; i < listOfRooms.length; i++ ) {
		//console.log('room is : ' + listOfRooms[i]);
		for ( var j = 0; j <  listOfRooms[i].users.length; j++ ) {
			if ( listOfRooms[i].users[j] == socket){
				listOfRooms[i].removeUserFromRoom(socket);
				if ( listOfRooms[i].isEmpty) {
					console.log('Empty room, removing room: ' + listOfRooms[i].name);
					customNsp.emit('removeRoomFromList', listOfRooms[i].name);
					listOfRooms.splice(i, 1);
					// If removing a room, put back this index by one to not skip a room.
					i--;
				}
			}
		}
	}
}

// When the leave Button is pressed. Removing user from rooms objects. Not general one.
function leaveRoomButton (socket){
	var roomsIn = socket.rooms;
	if (roomsIn){
		for ( var roomHere in roomsIn ) {
			if ( roomHere == socket.id || roomHere == "general") {
				continue;
			}  else {
				var index = getRoomIndex(roomHere);
				listOfRooms[index].removeUserFromRoom(socket);
				if (listOfRooms[index].isEmpty) {
					console.log('Empty room, removing room: ' + roomHere);
					customNsp.emit('removeRoomFromList', roomHere);
					listOfRooms.splice(index, 1);
				}
				console.log('leaving room ' + roomHere);
				socket.leave(roomHere);
			}
		}
	}
}

// Check rooms. If already in the room, return. Ignore personal room.
// Leave any other room before joining the new room.
function leaveRoom (socket, roomName) {
	//Get a list of the rooms the socket is in.
	var roomsIn = socket.rooms;
		if (roomsIn) {
			// This roomHere is the name of the room
			for (var roomHere in roomsIn) {
				//console.log(roomHere);
				//console.log(typeof roomHere);
				// If the room is the joining room, return.
				if (roomHere == roomName) {
					console.log('already here, exiting leaveRoom method');
					return;
				}
				// Skip general and personnal rooms.
				if (roomHere == socket.id || roomHere == "general"){
					//console.log('skip ' + roomHere);
					continue;
				// Else, remove the user from the room data. If the room
				// is empty, remove from the list of rooms. And send a 
				// message to the client to update the list of rooms.
				// Finally leave the room.
				} else {
					//console.log(listOfRooms);
					//console.log('entering leaveRoom else statement');
					//console.log('roomName is : ' + roomName);
					var index = getRoomIndex(roomHere);
					listOfRooms[index].removeUserFromRoom(socket);
					if (listOfRooms[index].isEmpty) {
						console.log('Empty room, removing room: ' + roomHere);
						customNsp.emit('removeRoomFromList', roomHere);
						listOfRooms.splice(index, 1);
					}
					console.log('leaving room ' + roomHere);
					socket.leave(roomHere);
				}
				
			}
		}
}

//Creating a new room object, pushing it the array and sending to display.
function createRoom (socket, roomName) {
	var newRoom = createNewRoomObject(roomName, socket);
	// To print to new room
	console.log('new room "' + roomName + '" created');
	//console.log(newRoom);
	if(newRoom != null) {
		listOfRooms.push(newRoom);
		customNsp.emit('addRoomToList', roomName);
	}
}
function createPrivateRoom (socket, roomName, user1, user2) {
	var newRoom = createNewRoomObject(roomName, socket);
	// To print to new room
	console.log('new room "' + roomName + '" created');
	//console.log(newRoom);
	if(newRoom != null) {
		listOfRooms.push(newRoom);
	}
}

function ifRoomExist (socket, roomName){
	console.log('room ' + roomName + ' already exist, joining it.');
	leaveRoom (socket, roomName);
	joinRoom(socket, roomName);
	var roomObject = getRoomObject(roomName);
	roomObject.addUserToRoom(socket);
	//console.log(roomObject.users);
	var roomChat = getRoomObject(roomName).chat;
	customNsp.to(roomName).emit('joined', roomName, roomChat, socket.nickname);
	for(var i = 0; i < roomObject.users.length; i++){
		console.log('users in room : ' + roomObject.users[i].nickname);
	}
}

function ifRoomDoesNotExist (socket, roomName){
	console.log('room ' + roomName + ' doesnt exist, creating it.');
	leaveRoom (socket, roomName);
	createRoom (socket, roomName);
	joinRoom(socket, roomName);
	var roomChat = getRoomObject(roomName).chat;
	customNsp.to(roomName).emit('joined', roomName, roomChat, socket.nickname);
	console.log('users : ' + getRoomObject(roomName).users.length);
}

function ifPrivateRoomExist (socket, roomName){
	console.log('room ' + roomName + ' already exist, joining it.');
	joinRoom(socket, roomName);
	var roomObject = getRoomObject(roomName);
	roomObject.addUserToRoom(socket);
	var roomChat = getRoomObject(roomName).chat;
	customNsp.to(roomName).emit('joinedPrivate', roomName, roomChat, socket.nickname);
	for(var i = 0; i < roomObject.users.length; i++){
		console.log('users in room : ' + roomObject.users[i].nickname);
	}
}

function ifPrivateRoomDoesNotExist (socket, roomName, user1, user2){
	console.log('room ' + roomName + ' doesnt exist, creating it.');
	createPrivateRoom (socket, roomName, user1, user2);
	joinRoom(socket, roomName);
	var roomChat = getRoomObject(roomName).chat;
	customNsp.to(roomName).emit('joinedPrivate', roomName, roomChat, socket.nickname);
	console.log('users : ' + getRoomObject(roomName).users.length);
}