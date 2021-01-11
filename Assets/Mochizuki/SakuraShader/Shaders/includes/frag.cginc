/*-------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *------------------------------------------------------------------------------------------*/

// #include "core.cginc"

#if defined(RENDER_PASS_FB) || defined(RENDER_PASS_FA)

float4 fs(const g2f v) : SV_TARGET
{
    const float4   vertexColor    = _UseVertexColor ? v.color : float4(1.0, 1.0, 1.0, 1.0);
    const float4   baseColor      = UNITY_SAMPLE_TEX2D(_MainTex, TRANSFORM_TEX(v.uv, _MainTex)) * _Color * vertexColor;
    const float3   lightColor     = _LightColor0.rgb;
    const float3   tangent        = normalize(v.tangent);
    const float3   binormal       = normalize(v.binormal);
    const float3   viewDir        = normalize(_WorldSpaceCameraPos - v.worldPos);
    const float3   lightDir       = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - v.worldPos, _WorldSpaceLightPos0.w));
    const float3   floatDir       = normalize(viewDir + lightDir);
    const float3x3 worldToTangent = float3x3(tangent, binormal, normalize(v.normal));
    const float3x3 tangentToWorld = transpose(worldToTangent);
    const float3   heightMap      = UNITY_SAMPLE_TEX2D_SAMPLER(_ParallaxMap, _MainTex, TRANSFORM_TEX(v.uv, _ParallaxMap));
    const float2   uv             = v.uv + ParallaxOffset(heightMap, _ParallaxScale, mul(worldToTangent, viewDir));
    const float3   normalMap      = UnpackScaleNormal(UNITY_SAMPLE_TEX2D_SAMPLER(_BumpMap, _MainTex, TRANSFORM_TEX(uv, _BumpMap)), _BumpScale);  
    const float3   normal         = normalize(mul(tangentToWorld, normalMap));

#if defined(SHADER_VARIANT_CUTOUT)
    clip(baseColor.a - _Cutout);
#endif

    UNITY_LIGHT_ATTENUATION(attenuation, v, v.worldPos.xyz);

#if defined(RENDER_PASS_FB)
    const float3 ambient      = ShadeSH9(half4(normal, 1));
    const float3 ambientColor = float3(ambient + v.vertexLight) * baseColor.rgb;
#else
    const float3 ambientColor = float3(0.0, 0.0, 0.0);
#endif // RENDER_PASS_FB
    const float  diffuse      = pow(saturate(dot(normal, lightDir)) * 0.5 + 0.5, 2);
    const float3 diffuseColor = diffuse * baseColor.rgb * lightColor * attenuation;

    float3 emissionColor = float3(0.0, 0.0, 0.0);
#if defined(RENDER_PASS_FB)
    if (_EnableEmission)
    {
        emissionColor += _EmissionColor.rgb * _EmissionIntensity;
        emissionColor *= UNITY_SAMPLE_TEX2D_SAMPLER(_EmissionMask, _MainTex, TRANSFORM_TEX(uv, _EmissionMask)).rgb;
    }
#endif // RENDER_PASS_FB

#if defined(SHADER_VARIANT_TRANSPARENT)
    const float alphaMask = 1 - toMonochrome(UNITY_SAMPLE_TEX2D_SAMPLER(_AlphaMask, _MainTex, TRANSFORM_TEX(uv, _AlphaMask)));
    const float alpha     = lerp(1.0, baseColor.a * alphaMask, _Alpha);
    float4 finalColor     = float4(ambientColor + diffuseColor + emissionColor, alpha);
#else
    float4 finalColor     = float4(ambientColor + diffuseColor + emissionColor, 1.0);
#endif // SHADER_VARIANT_TRANSPARENT

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