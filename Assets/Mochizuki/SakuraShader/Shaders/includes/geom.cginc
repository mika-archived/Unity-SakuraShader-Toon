/*-------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *------------------------------------------------------------------------------------------*/

// #include "core.cginc"

[maxvertexcount(24)]
void gs(triangle const v2g input[3], const uint id : SV_PRIMITIVEID, inout TriangleStream<g2f> stream)
{
    [unroll]
    for (int i = 0; i < 3; i++)
    {
        const v2g v = input[i];

        g2f o;
#if defined(RENDER_PASS_FB) || defined(RENDER_PASS_FA)
        o.vertex   = UnityObjectToClipPos(v.vertex);
        o.worldPos = mul(unity_ObjectToWorld, v.vertex);
        o.normal   = UnityObjectToWorldNormal(v.normal);
        o.uv       = v.uv;
        o.color    = v.color;
        o.tangent  = v.tangent;
        o.binormal = UnityObjectToWorldDir(cross(v.normal, v.tangent) * v.tangent.w);

        TRANSFER_SHADOW(o);
        UNITY_TRANSFER_FOG(o, o.vertex);
#elif defined(RENDER_PASS_OL_FB)
        if (_EnableOutline)
        {
            o.normal   = UnityObjectToWorldNormal(v.normal);
            o.worldPos = mul(unity_ObjectToWorld, float4(v.vertex.xyz, 0)) + float4(normalize(o.normal), 0) * _OutlineWidth * 0.01;
            o.vertex   = UnityObjectToClipPos(o.worldPos);
        }
        else
        {
            o.vertex   = UnityObjectToClipPos(v.vertex);
            o.worldPos = mul(unity_ObjectToWorld, v.vertex);
            o.normal   = UnityObjectToWorldNormal(v.normal);
        }

        o.uv       = v.uv;
        o.color    = v.color;
        o.tangent  = v.tangent;
        o.binormal = UnityObjectToWorldDir(cross(v.normal, v.tangent) * v.tangent.w);

        TRANSFER_SHADOW(o);
        UNITY_TRANSFER_FOG(o, o.vertex);
#elif defined(RENDER_PASS_SC)
        TRANSFER_SHADOW_CASTER_NORMALOFFSET(o);
#endif

        stream.Append(o);
    }

    stream.RestartStrip();
}