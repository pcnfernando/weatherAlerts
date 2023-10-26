# Realtime Weather Alerting

## Getting Started

Follow these steps to get started with this demo:

1. Download and install `ballerina` from [https://ballerina.io/downloads/]
2. Clone the repository:

   ```bash
   git clone https://github.com/pcnfernando/weatherAlerts.git
   ```

3. Change to the project directory:

   ```bash
   cd weatherAlerts
   ```

4. Create a `Config.toml` file in the root directory with the following content:

   ```toml
   # Configuration file for "weatherAlerts"
   # How to use see:
   # https://ballerina.io/learn/configure-ballerina-programs/provide-values-to-configurable-variables/#provide-via-toml-syntax


   API_KEY = <WEATHER_API_KEY>	# Type of STRING

   TWILIO_ACC_SId = <SID>	# Type of STRING
   TWILIO_AUTH_TOKEN = <TOKEN>	# Type of STRING
   FROM_NUMBER = <NUMBER>	# Type of STRING

    [weatherAlerts.store]
   host = "localhost"
   port = 3307
   user = "dbuser"
   password = "dbuser"
   database = "weatherDb"
   ```

   You can modify the configuration as needed for your application.

5. Run below command to configure the MySQL database
   ```bash
   docker compose up
   ```

6. Run the application using the Bal tool:

   ```bash
   bal run
   ```

   This command will use the configuration in `Config.toml` to start your application.

7. This will expose a user alert configurable endpoint in
   ``` 
   http://localhost:9090/weather
   ```

   Example request
   ```
   {
    "location": "string",
    "condition": "string",
    "contactNum": "string"
   }
   ```
