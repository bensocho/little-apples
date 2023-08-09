FROM mongo:4.4-rc

# Expose the default MongoDB port
EXPOSE 27017

# Copy the init-data.json file into the container
COPY init-data.js /docker-entrypoint-initdb.d/

# Command to start MongoDB
CMD ["mongod"]

