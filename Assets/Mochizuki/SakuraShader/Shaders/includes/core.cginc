/*-------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *------------------------------------------------------------------------------------------*/

#include "UnityCG.cginc"
#include "AutoLight.cginc"
#include "Lighting.cginc"

// ref: https://docs.unity3d.com/ja/2018.4/Manual/SL-SamplerStates.html

// Main Shading
uniform Texture2D    _MainTex;
uniform SamplerState sampler_MainTex;
uniform float4       _MainTex_ST;
uniform fixed4       _Color;
uniform float        _Alpha;
uniform float        _Cutout;
uniform int          _UseVertexColor;
uniform Texture2D    _BumpMap;
uniform float4       _BumpMap_ST;

// Toon Shading
uniform int          _EnableToon;
uniform float        _ToonStrength;

// Lightings
uniform int          _EnableCustomLightings;
uniform float        _Unlighting;

// Emission
uniform int          _EnableEmission;
uniform Texture2D    _EmissionMask;
uniform float4       _EmissionMask_ST;
uniform float4       _EmissionColor;

// Parallax Emission
uniform int          _EnableParallaxEmission;
uniform sampler2D    _ParallaxEmissionTex;
uniform float4       _ParallaxEmissionTex_ST;
uniform Texture2D    _ParallaxEmissionMask;
uniform float4       _ParallaxEmissionMask_ST;

// Rim Lighting
uniform int          _EnableRimLighting;
uniform Texture2D    _RimLightingMask;
uniform float4       _RimLightingMask_ST;
uniform float4       _RimLightingColor;

// Reflection
uniform int          _EnableReflection;

// Outline
uniform int          _EnableOutline;
uniform float        _OutlineWidth;
uniform float4       _OutlineColor;
uniform Texture2D    _OutlineMask;
uniform float4       _OutlineMask_ST;

// Voxelization
uniform int          _EnableVoxelization;

// Wireframe
uniform int          _EnableWireframe;


struct appdata
{
    float4 vertex  : POSITION;
    float2 uv      : TEXCOORD0;
    float3 normal  : NORMAL;
    float4 tangent : TANGENT;
    float4 color   : COLOR;
};

struct v2g
{
    float4 vertex  : POSITION;
    float2 uv      : TEXCOORD0;
    float3 normal  : NORMAL;
    float4 tangent : TANGENT;
    float4 color   : COLOR;
};

struct g2f
{
#if defined(RENDER_PASS_FB) || defined(RENDER_PASS_FA)
    float4 vertex : SV_POSITION;
    float2 uv     : TEXCOORD0;
    float3 normal : NORMAL;
    float4 color  : COLOR;
#elif defined(RENDER_PASS_SC)
    V2F_SHADOW_CASTER;
#endif
};

#include "vert.cginc"
// #include "hull.cginc"
#include "geom.cginc"
#include "frag.cginc"