shader_type canvas_item;

uniform float Zoom : hint_range(0.1, 10) = 2.0;
uniform float Brightness : hint_range(0.0, 3.0) = 1.0;
uniform vec3 startingRayPos = vec3(0.0, -0.2, -6.5);
uniform vec3 startingRayRot = vec3(0.0);


const vec4[5] spheres = {
	vec4(0.5, 0.5, 2.0, 0.5),
	vec4(0.2, 0.8, 1.0, 0.2),
	vec4(1.0, 0.3, -0.5, 0.3),
	vec4(-1.0, 0.7, -0.2, 0.25),
	vec4(0.0, 0.1, 0.2, 0.2)
};

const vec4[5] sphereColors = {
	vec4(0.3, 0.3, 0.3, 1.0),
	vec4(0.9, 0.1, 0.8, 1.0),
	vec4(0.2, 0.1, 0.8, 1.0),
	vec4(0.0, 0.8, 0.5, 1.0),
	vec4(0.0, 0.8, 0.5, 1.0)
};


void fragment() {
	vec4 pixelColor = vec4(0.0, 0.0, 0.0, 1.0);
	vec4 sphereColor = pixelColor;
	int hitSphere = -1;
	
	vec3 rayDir = vec3(0.0, 0.0, 1.0);
	rayDir.x += (UV.x - 0.5) / Zoom;
	rayDir.y += (UV.y - 0.5) / Zoom;
	
	{
		vec3 newRayDir = rayDir;
		newRayDir.x = rayDir.x * cos(startingRayRot.y) + rayDir.z * sin(startingRayRot.y);
		newRayDir.z = -rayDir.x * sin(startingRayRot.y) + rayDir.z * cos(startingRayRot.y);
		
		rayDir = newRayDir;
	}
	
	//rayDir = normalize(rayDir);
	
	vec3 rayPos = startingRayPos;
	rayPos.x += UV.x;
	rayPos.y += UV.y;
	
	{
		vec3 newRayPos = rayPos;
		newRayPos.x = rayPos.x * cos(startingRayRot.y) + rayPos.z * sin(startingRayRot.y);
		newRayPos.z = -rayPos.x * sin(startingRayRot.y) + rayPos.z * cos(startingRayRot.y);
		
		rayPos = newRayPos;
	}
	
	
	int maxRays = 100;
	for(int i = 0; i < maxRays; i++) {
		float dist = 4000.0;
		
		for(int j = 0; j < spheres.length(); j++) {
			float distToSphere = sqrt(
				pow(rayPos.x-spheres[j].x, 2) +
				pow(rayPos.y-spheres[j].y, 2) +
				pow(rayPos.z-spheres[j].z, 2)
			) - spheres[j].w;
			
			if (distToSphere < 0.0001) {
				hitSphere = j;
				sphereColor = sphereColors[j];
			}
			
			dist = min(dist, distToSphere);
		}
		
		rayPos += rayDir * dist;
	}
	
	vec3 normal = (rayPos - spheres[hitSphere].xyz) - spheres[hitSphere].w;
	
	pixelColor = sphereColor;
	pixelColor *= length(normal);
	
	pixelColor.a = 1.0;
	//pixelColor.a = clamp(pixelColor.a, 0.0, 1.0);
	
	
	pixelColor *= Brightness;
	
	COLOR = pixelColor;
	
}
