FROM python:alpine
COPY . /app                            
WORKDIR /app
RUN pip install -r requirements.txt
EXPOSE 80
CMD python ./phonebook-app.py

# Copy the alpine image to the app file
# Install and run requrements "flask and flask-mysql"