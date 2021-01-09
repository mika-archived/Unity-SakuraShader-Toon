/*-------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *------------------------------------------------------------------------------------------*/

inline float toMonochrome(fixed4 color)
{
    return color.r * 0.2126 + color.g * 0.7152 + color.b * 0.0722;
}