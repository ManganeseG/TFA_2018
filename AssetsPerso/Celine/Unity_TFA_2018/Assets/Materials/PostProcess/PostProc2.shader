// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "HEAJ/PostProcess2"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_MaxFogDistance("MaxFogDistance", Float) = 0
		_FogColor("FogColor", Color) = (0,0,0,0)
		_MinFogDistance("MinFogDistance", Float) = 0
		_PointOfInterest("PointOfInterest", Vector) = (0,0,0,0)
		_RingFrequency("RingFrequency", Range( 0 , 100)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	SubShader
	{
		
		
		ZTest Always
		Cull Off
		ZWrite Off
		

		Pass
		{ 
			CGPROGRAM 

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				float4 ase_texcoord4 : TEXCOORD4;
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform float4 _FogColor;
			uniform float _MinFogDistance;
			uniform float _MaxFogDistance;
			uniform float3 _PointOfInterest;
			uniform float4x4 CameraInvView;
			uniform sampler2D _CameraDepthTexture;
			uniform float _RingFrequency;

			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord4 = screenPos;
				
				o.pos = UnityObjectToClipPos ( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float2 uv_MainTex = i.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 screenPos = i.ase_texcoord4;
				float4 ase_screenPosNorm = screenPos/screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float eyeDepth23 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD(ase_screenPosNorm))));
				float4x4 break28 = unity_CameraProjection;
				float2 appendResult29 = (float2(break28[ 0 ][ 0 ] , break28[ 1 ][ 1 ]));
				float3 appendResult34 = (float3(( ( ( (ase_screenPosNorm).xy * float2( 2,2 ) ) - float2( 1,1 ) ) / appendResult29 ) , -1));
				float4 appendResult36 = (float4(( eyeDepth23 * appendResult34 ) , 1));
				float temp_output_40_0 = distance( float4( _PointOfInterest , 0.0 ) , mul( CameraInvView, appendResult36 ) );
				float smoothstepResult26 = smoothstep( _MinFogDistance , _MaxFogDistance , temp_output_40_0);
				float mulTime44 = _Time.y * 1;
				float4 lerpResult18 = lerp( tex2D( _MainTex, uv_MainTex ) , _FogColor , ( smoothstepResult26 * abs( ( smoothstepResult26 * sin( ( ( temp_output_40_0 * _RingFrequency ) + mulTime44 ) ) ) ) ));
				

				finalColor = lerpResult18;

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15201
538;248;1370;1004;-1413.156;1478.545;2.737789;True;True
Node;AmplifyShaderEditor.ScreenPosInputsNode;22;76.78868,-56.10223;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;30;362.4963,80.97247;Float;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CameraProjectionNode;27;218.0521,506.9065;Float;False;unity_CameraProjection;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;549.8606,231.4757;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;28;472.9268,506.6859;Float;False;FLOAT4x4;1;0;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;29;756.0925,504.6577;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;32;749.2172,351.5186;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;1,1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;33;957.149,422.2577;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;34;1205.322,421.299;Float;False;FLOAT3;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;-1;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ScreenDepthNode;23;761.6744,-55.15623;Float;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;1403.679,406.011;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;36;1582.152,406.7902;Float;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Matrix4X4Node;37;1649.219,195.441;Float;False;Global;CameraInvView;CameraInvView;2;0;Create;True;0;0;False;0;1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;2052.356,328.3609;Float;False;2;2;0;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector3Node;39;2039.541,72.81905;Float;False;Property;_PointOfInterest;PointOfInterest;3;0;Create;True;0;0;False;0;0,0,0;2.41,0,-2.21;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;41;2463.75,580.437;Float;False;Property;_RingFrequency;RingFrequency;4;0;Create;True;0;0;False;0;0;50.7;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;40;2356.756,242.9115;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;2796.533,327.0287;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;44;2770.489,582.4736;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;42;3016.124,441.0876;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;2309.426,455.0443;Float;False;Property;_MaxFogDistance;MaxFogDistance;0;0;Create;True;0;0;False;0;0;3.67;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;2314.577,363.2015;Float;False;Property;_MinFogDistance;MinFogDistance;2;0;Create;True;0;0;False;0;0;4.53;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;48;3174.301,439.2854;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;26;2749.721,-78.75884;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;3359.951,371.9341;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;50;3548.563,329.4301;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;21;825.5811,-335.8204;Float;False;0;0;_MainTex;Shader;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;3685.409,292.7134;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;17;1448.609,-459.8405;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;20;3425.459,-68.40107;Float;False;Property;_FogColor;FogColor;1;0;Create;True;0;0;False;0;0,0,0,0;0.8676471,0.2615701,0.2615701,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;18;3771.541,-145.0155;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;3963.541,-145.0155;Float;False;True;2;Float;ASEMaterialInspector;0;1;HEAJ/PostProcess2;c71b220b631b6344493ea3cf87110c93;0;0;SubShader 0 Pass 0;1;False;False;True;Off;False;False;True;2;True;7;False;True;0;False;0;0;0;False;False;False;False;False;False;False;False;False;True;2;0;0;0;1;0;FLOAT4;0,0,0,0;False;0
WireConnection;30;0;22;0
WireConnection;31;0;30;0
WireConnection;28;0;27;0
WireConnection;29;0;28;0
WireConnection;29;1;28;5
WireConnection;32;0;31;0
WireConnection;33;0;32;0
WireConnection;33;1;29;0
WireConnection;34;0;33;0
WireConnection;23;0;22;0
WireConnection;35;0;23;0
WireConnection;35;1;34;0
WireConnection;36;0;35;0
WireConnection;38;0;37;0
WireConnection;38;1;36;0
WireConnection;40;0;39;0
WireConnection;40;1;38;0
WireConnection;45;0;40;0
WireConnection;45;1;41;0
WireConnection;42;0;45;0
WireConnection;42;1;44;0
WireConnection;48;0;42;0
WireConnection;26;0;40;0
WireConnection;26;1;24;0
WireConnection;26;2;25;0
WireConnection;52;0;26;0
WireConnection;52;1;48;0
WireConnection;50;0;52;0
WireConnection;46;0;26;0
WireConnection;46;1;50;0
WireConnection;17;0;21;0
WireConnection;18;0;17;0
WireConnection;18;1;20;0
WireConnection;18;2;46;0
WireConnection;0;0;18;0
ASEEND*/
//CHKSM=D6C90AD44062E78D2560E19B1A0799654F04D3B1