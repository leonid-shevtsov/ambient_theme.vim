bin/light_sensor:
	gcc -o bin/light_sensor src/light_sensor.cpp -framework IOKit -framework CoreFoundation

clean:
	rm bin/light_sensor
