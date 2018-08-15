// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "HEAJ/Celine/DoubleTexture"
{
	Properties
	{
		_TextNormal("TextNormal", 2D) = "bump" {}
		_RockTex("RockTex", 2D) = "white" {}
		_TextTexture("TextTexture", 2D) = "white" {}
		_RockNormal("RockNormal", 2D) = "bump" {}
		_TextColor("TextColor", Color) = (1,0.2941176,0.2941176,0)
		_Intensity("Intensity", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 5.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _RockNormal;
		uniform float4 _RockNormal_ST;
		uniform sampler2D _TextNormal;
		uniform float4 _TextNormal_ST;
		uniform sampler2D _RockTex;
		uniform float4 _RockTex_ST;
		uniform sampler2D _TextTexture;
		uniform float4 _TextTexture_ST;
		uniform float4 _TextColor;
		uniform float _Intensity;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_RockNormal = i.uv_texcoord * _RockNormal_ST.xy + _RockNormal_ST.zw;
			float2 uv_TextNormal = i.uv_texcoord * _TextNormal_ST.xy + _TextNormal_ST.zw;
			o.Normal = BlendNormals( UnpackNormal( tex2D( _RockNormal, uv_RockNormal ) ) , UnpackNormal( tex2D( _TextNormal, uv_TextNormal ) ) );
			float2 uv_RockTex = i.uv_texcoord * _RockTex_ST.xy + _RockTex_ST.zw;
			float2 uv_TextTexture = i.uv_texcoord * _TextTexture_ST.xy + _TextTexture_ST.zw;
			float4 temp_output_25_0 = ( tex2D( _TextTexture, uv_TextTexture ) * _TextColor );
			float4 lerpResult26 = lerp( tex2D( _RockTex, uv_RockTex ) , temp_output_25_0 , 0.5);
			o.Albedo = lerpResult26.rgb;
			o.Emission = ( temp_output_25_0 * _Intensity ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15201
379;29;1370;1004;2077.434;1106.16;1.985762;True;True
Node;AmplifyShaderEditor.SamplerNode;1;-797.5602,-146.7787;Float;True;Property;_TextTexture;TextTexture;3;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;6;-720.3339,68.88862;Float;False;Property;_TextColor;TextColor;5;0;Create;True;0;0;False;0;1,0.2941176,0.2941176,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-786.2073,257.5766;Float;True;Property;_RockNormal;RockNormal;4;0;Create;True;0;0;False;0;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-803.0795,-378.4993;Float;True;Property;_RockTex;RockTex;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-224.025,-36.05105;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-276.607,188.2312;Float;False;Property;_Intensity;Intensity;6;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-783.4982,515.7;Float;True;Property;_TextNormal;TextNormal;0;0;Create;True;0;0;False;0;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendNormalsNode;13;-404.9042,362.1226;Float;True;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;188.3753,-21.48936;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;26;166.6416,-203.3547;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.5;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;510.3317,-117.7202;Float;False;True;7;Float;ASEMaterialInspector;0;0;Standard;HEAJ/Celine/DoubleTexture;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;0;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;4;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;25;0;1;0
WireConnection;25;1;6;0
WireConnection;13;0;2;0
WireConnection;13;1;3;0
WireConnection;28;0;25;0
WireConnection;28;1;29;0
WireConnection;26;0;4;0
WireConnection;26;1;25;0
WireConnection;0;0;26;0
WireConnection;0;1;13;0
WireConnection;0;2;28;0
ASEEND*/
//CHKSM=6878FB67D078E94E8ED3D6D49F3D9A4B0445AE66