Shader "HEAJ/Celine/Distortion"
{
	Properties
	{
		[Normal]_NormalTex ("Normal", 2D) = "bump" {}
		[HDR]_MainColor("Main Color", Color) = (1,1,1,1)
		_Distortion ("Distortion", Float) = 100
	}

	SubShader
	{
		GrabPass {			
			"_GrabTexture"
 		}

		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		ZWrite Off
		Cull Off
		LOD 100
		Blend SrcAlpha OneMinusSrcAlpha
		
		Pass
		{
			CGPROGRAM
			#pragma target 3.0

			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog

			float4 _GrabTexture_TexelSize;
			float2 GetGrabTexelSize(){ return _GrabTexture_TexelSize.xy; }
			half2 GrabScreenPosXY(float4 vertex)
			{
					return (float2(vertex.x, -vertex.y) + vertex.w) * 0.5;
			}

			#include "UnityCG.cginc"
			#include "Distortion.cginc"
			ENDCG
		}
	}
}
