/*
 * Copyright (c) 2007, elvman
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY elvman ``AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL elvman BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

uniform vec3		CameraPosition;  // Position of main position
uniform float		WaveHeight;

uniform vec4		WaterColor;
uniform float		ColorBlendFactor;

uniform sampler2D	WaterBump; //coverage
uniform sampler2D	RefractionMap; //coverage
uniform sampler2D	ReflectionMap; //coverage

varying vec2 bumpMapTexCoord;
varying vec3 refractionMapTexCoord;
varying vec3 reflectionMapTexCoord;
varying vec3 position3D;
	
void main()
{
	//bump color
	vec4 bumpColor = texture2D(WaterBump, bumpMapTexCoord);
	vec2 perturbation = WaveHeight * (bumpColor.rg - 0.5);
	
	//refraction
	vec2 ProjectedRefractionTexCoords = clamp(refractionMapTexCoord.xy / refractionMapTexCoord.z + perturbation, 0.0, 1.0);
	//calculate final refraction color
	vec4 refractiveColor = texture2D(RefractionMap, ProjectedRefractionTexCoords );
	
	//reflection
	vec2 ProjectedReflectionTexCoords = clamp(reflectionMapTexCoord.xy / reflectionMapTexCoord.z + perturbation, 0.0, 1.0);
	//calculate final reflection color
	vec4 reflectiveColor = texture2D(ReflectionMap, ProjectedReflectionTexCoords );

	//fresnel
	vec3 eyeVector = normalize(CameraPosition - position3D);
	vec3 upVector = vec3(0.0, 1.0, 0.0);
	
	//fresnel can not be lower than 0
	float fresnelTerm = max( dot(eyeVector, upVector), 0.0 );
	
	vec4 combinedColor = refractiveColor * fresnelTerm + reflectiveColor * (1.0 - fresnelTerm);
	
	gl_FragColor = ColorBlendFactor * WaterColor + (1.0 - ColorBlendFactor) * combinedColor;
}

