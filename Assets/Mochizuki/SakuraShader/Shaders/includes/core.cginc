/*-------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *------------------------------------------------------------------------------------------*/

#include "UnityCG.cginc"
#include "AutoLight.cginc"
#include "Lighting.cginc"

// ref: https://docs.unity3d.com/ja/2018.4/Manual/SL-SamplerStates.html

// Main Shading
UNITY_DECLARE_TEX2D(_MainTex);
uniform float4       _MainTex_ST;
uniform fixed4       _Color;
uniform float        _Alpha;
UNITY_DECLARE_TEX2D_NOSAMPLER(_AlphaMask);
uniform float4       _AlphaMask_ST;
uniform float        _Cutout;
UNITY_DECLARE_TEX2D_NOSAMPLER(_CutoutMask);
uniform float4       _CutoutMask_ST;
uniform int          _UseVertexColor;
uniform int          _VertexColorBlendMode;
UNITY_DECLARE_TEX2D_NOSAMPLER(_BumpMap);
uniform float4       _BumpMap_ST;
UNITY_DECLARE_TEX2D_NOSAMPLER(_OcclusionMap);
uniform float4       _OcclusionMap_ST;

// Toon Shading
uniform int          _EnableToon;
uniform float        _ToonStrength;

// Lightings
uniform int          _EnableCustomLightings;
uniform float        _Unlighting;

// Emission
uniform int          _EnableEmission;
uniform float4       _EmissionColor;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissionMask);
uniform float4       _EmissionMask_ST;

// Parallax Emission
uniform int          _EnableParallaxEmission;
uniform sampler2D    _ParallaxEmissionTex;
uniform float4       _ParallaxEmissionTex_ST;
UNITY_DECLARE_TEX2D_NOSAMPLER(_ParallaxEmissionMask);
uniform float4       _ParallaxEmissionMask_ST;

// Rim Lighting
uniform int          _EnableRimLighting;
uniform float4       _RimLightingColor;
UNITY_DECLARE_TEX2D_NOSAMPLER(_RimLightingMask);
uniform float4       _RimLightingMask_ST;

// Reflection
uniform int          _EnableReflection;
UNITY_DECLARE_TEX2D_NOSAMPLER(_ReflectionMask);
uniform float4       _ReflectionMask_ST;
uniform float        _ReflectionSmoothness;

// Outline
uniform int          _EnableOutline;
uniform float        _OutlineWidth;
uniform float4       _OutlineColor;
uniform sampler2D    _OutlineTex;
uniform float4       _OutlineTex_ST;
UNITY_DECLARE_TEX2D_NOSAMPLER(_OutlineMask);
uniform float4       _OutlineMask_ST;
uniform int          _UseMainTexColorInOutline;

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
#if defined(RENDER_PASS_FB) || defined(RENDER_PASS_FA) || defined(RENDER_PASS_OL_FB)
    float4 vertex : SV_POSITION;
    float2 uv     : TEXCOORD0;
    float3 normal : NORMAL;
    float4 color  : COLOR;
#elif defined(RENDER_PASS_SC)
    V2F_SHADOW_CASTER;
#endif
};

#include "func.cginc"
#include "vert.cginc"
// #include "hull.cginc"
#include "geom.cginc"
#include "frag.cginc"