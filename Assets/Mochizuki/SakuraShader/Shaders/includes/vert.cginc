/*-------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *------------------------------------------------------------------------------------------*/

// #include "core.cginc"

v2g vs(const appdata v)
{
    v2g o;
    o.vertex  = v.vertex;
    o.uv      = v.uv;
    o.normal  = v.normal;
    o.tangent = v.tangent;
    o.color   = v.color;

    return o;
}