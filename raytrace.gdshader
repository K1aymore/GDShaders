shader_type canvas_item;

uniform float Zoom : hint_range(0.1, 10) = 0.5;
uniform float Brightness : hint_range(0.0, 3.0) = 1.0;
uniform vec3 startingRayPos = vec3(-0.69, 0.0, -3);
uniform vec3 startingRayRot = vec3(0.0);

const int sphereCount = 9;
const vec4[sphereCount] spheres = {
	vec4(0.5, 0.5, 1.0, 0.5),
	vec4(-1.0, 1.2, 0.5, 0.3),
	vec4(1.0, 0.3, -1.0, 0.3),
	vec4(-0.6, 0.7, -0.7, 0.34),
	vec4(0.0, -0.5, -0.3, 0.4),
	vec4(1.0, 1.5, 0.0, 0.35),
	vec4(1.5, 0.0, 0.0, 0.35),
	vec4(-0.6, 0.1, 1.0, 0.30),
	vec4(0.0, 0.5, 0.0, 0.30)
};

const vec4[sphereCount] sphereColors = {
	vec4(0.3, 0.3, 0.3, 1.0),
	vec4(0.9, 0.2, 0.6, 1.0),
	vec4(0.2, 0.1, 0.8, 1.0),
	vec4(0.6, 0.0, 0.4, 1.0),
	vec4(0.0, 1.0, 0.7, 1.0),
	vec4(0.7, 0.0, 0.0, 1.0),
	vec4(0.4, 0.0, 0.9, 1.0),
	vec4(0.4, 0.3, 0.3, 1.0),
	vec4(0.5, 0.5, 0.5, 1.0)
};




float findDistToSphere(vec3 pos, int sphereNum) {
	float dist;
	vec4 sphere = spheres[sphereNum];
	dist = sqrt(
		pow(pos.x-sphere.x, 2) +
		pow(pos.y-sphere.y, 2) +
		pow(pos.z-sphere.z, 2)
	) - sphere.w;
	
	return dist;
}


void fragment() {
	vec4 pixelColor = vec4(0.0, 0.0, 0.0, 1.0);
	vec4 rayColor = pixelColor;
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
	{
		vec3 newRayDir = rayDir;
		newRayDir.y = rayDir.y * cos(startingRayRot.x) - rayDir.z * sin(startingRayRot.x);
		newRayDir.z = rayDir.y * sin(startingRayRot.x) + rayDir.z * cos(startingRayRot.x);
		
		rayDir = newRayDir;
	}
	
	
	vec3 rayPos = startingRayPos;
	rayPos.x += UV.x;
	rayPos.y += UV.y;
	
	{
		vec3 newRayPos = rayPos;
		newRayPos.x = rayPos.x * cos(startingRayRot.y) + rayPos.z * sin(startingRayRot.y);
		newRayPos.z = -rayPos.x * sin(startingRayRot.y) + rayPos.z * cos(startingRayRot.y);
		
		rayPos = newRayPos;
	}
	{
		vec3 newRayPos = rayPos;
		newRayPos.y = rayPos.y * cos(startingRayRot.x) - rayPos.z * sin(startingRayRot.x);
		newRayPos.z = rayPos.y * sin(startingRayRot.x) + rayPos.z * cos(startingRayRot.x);
		
		rayPos = newRayPos;
	}
	
	
	
	int maxRays = 100;
	for(int i = 0; i < maxRays; i++) {
		float dist = 4000.0;
		
		for(int j = 0; j < spheres.length(); j++) {
			float distToSphere = findDistToSphere(rayPos, j);
			
			float rayTestDist = findDistToSphere(rayPos + rayDir, j);
			
			if (distToSphere < 0.0001) {
				vec3 normal = rayPos - spheres[j].xyz;
				
				rayColor = mix(rayColor, sphereColors[j], 0.9);
				
				rayColor.a = 1.0;
				
				float angle = PI;
				
				normal = normalize(normal);
				
				rayDir = -rayDir;
				rayDir = rayDir*cos(angle) + cross(normal, rayDir) * sin(angle) + normal * dot(normal, rayDir)*(1.0-cos(angle));
				rayPos += rayDir * 0.2;
			}
			
			dist = min(dist, distToSphere);
		}
		
		rayDir = normalize(rayDir);
		rayPos += rayDir * dist;
	}
	
	vec3 normal = (rayPos - spheres[hitSphere].xyz) - spheres[hitSphere].w;
	
	pixelColor = rayColor;
	//pixelColor *= length(normal);
	
	pixelColor.a = 1.0;
	//pixelColor.a = clamp(pixelColor.a, 0.0, 1.0);
	
	pixelColor *= Brightness;
	
	COLOR = pixelColor;
	
}
