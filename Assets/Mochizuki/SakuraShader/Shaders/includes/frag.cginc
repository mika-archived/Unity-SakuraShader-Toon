/*-------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *------------------------------------------------------------------------------------------*/

// #include "core.cginc"

#if defined(RENDER_PASS_FB) || defined(RENDER_PASS_FA)

float4 fs(const g2f v) : SV_TARGET
{
    const float4   baseColor        = UNITY_SAMPLE_TEX2D(_MainTex, TRANSFORM_TEX(v.uv, _MainTex)) * _Color;
    const float3   lightColor       = _LightColor0.rgb;
    const float3   tangent          = normalize(v.tangent);
    const float3   binormal         = normalize(v.binormal);
    const float3   viewDir          = normalize(_WorldSpaceCameraPos - v.worldPos);
    const float3   lightDir         = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - v.worldPos, _WorldSpaceLightPos0.w));
    const float3   floatDir         = normalize(viewDir + lightDir);
    const float3x3 worldToTangent   = float3x3(tangent, binormal, normalize(v.normal));
    const float3x3 tangentToWorld = transpose(worldToTangent);
    const float3   heightMap        = UNITY_SAMPLE_TEX2D_SAMPLER(_ParallaxMap, _MainTex, TRANSFORM_TEX(v.uv, _ParallaxMap));
    const float2   uv               = v.uv + ParallaxOffset(heightMap, _ParallaxScale, mul(worldToTangent, viewDir));
    const float3   normalMap        = UnpackScaleNormal(UNITY_SAMPLE_TEX2D_SAMPLER(_BumpMap, _MainTex, TRANSFORM_TEX(uv, _BumpMap)), _BumpScale);  
    const float3   normal           = normalize(mul(tangentToWorld, normalMap));

#if defined(SHADOWS_SCREEN)
    const float  attenuation = 1.0;
#if defined(SHADER_VARIANT_CUTOUT)
    clip(baseColor.a - _Cutout);
#endif

#else
    UNITY_LIGHT_ATTENUATION(attenuation, v, v.worldPos.xyz);
#endif

    const float  diffuse = pow(saturate(dot(normal, lightDir)) * 0.5 + 0.5, 2);

    float4 finalColor = baseColor * diffuse * float4(lightColor, 1.0);
    UNITY_APPLY_FOG(v.fogCoord, finalColor);

    return finalColor; 
}

#elif defined(RENDER_PASS_OL_FB)

float4 fs(const g2f v) : SV_TARGET
{
    float4 baseColor = tex2D(_OutlineTex, TRANSFORM_TEX(v.uv, _OutlineTex)) * _OutlineColor;

    if (_UseMainTexColorInOutline)
    {
        baseColor.rgb *= UNITY_SAMPLE_TEX2D(_MainTex, TRANSFORM_TEX(v.uv, _MainTex));
    }

    const float outlineMask = toMonochrome(UNITY_SAMPLE_TEX2D_SAMPLER(_OutlineMask, _MainTex, TRANSFORM_TEX(v.uv, _OutlineMask)));
    clip(outlineMask - 0.2);
    
    return baseColor;
}

#elif defined(RENDER_PASS_SC)

float4 fs(const g2f v) : SV_TARGET
{
    SHADOW_CASTER_FRAGMENT(v)
}

#endif