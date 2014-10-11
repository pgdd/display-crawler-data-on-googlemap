# # mongoose 3.8.x
# mongoose = Meteor.npmRequire("mongoose")

# # mongodb-uri 0.9.x
# uriUtil = Meteor.npmRequire("mongodb-uri")

# #
# # * Mongoose by default sets the auto_reconnect option to true.
# # * We recommend setting socket options at both the server and replica set level.
# # * We recommend a 30 second connection timeout because it allows for
# # * plenty of time in most operating environments.
# #
# options =
#   server:
#     socketOptions:
#       keepAlive: 1
#       connectTimeoutMS: 30000

#   replset:
#     socketOptions:
#       keepAlive: 1
#       connectTimeoutMS: 30000


# #
# # * Mongoose uses a different connection string format than MongoDB's standard.
# # * Use the mongodb-uri library to help you convert from the standard format to
# # * Mongoose's format.
# #
# mongodbUri = "mongodb://pierre:dbpassword@linus.mongohq.com:10097/crawler-db"
# mongooseUri = uriUtil.formatMongoose(mongodbUri)
# mongoose.connect mongooseUri, options
# conn = mongoose.connection
# conn.on "error", console.error.bind(console, "connection error:")
# conn.once "open", ->


# # Wait for the database connection to establish, then start the app.