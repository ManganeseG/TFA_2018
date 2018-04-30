
	sampler2D _GrabTexture;
	sampler2D _NormalTex;
	float4 _NormalTex_ST;
	half4 _MainColor;
	half _Distortion;

	sampler2D _CameraDepthTexture;
	float4x4 _InverseTransformMatrix;

	struct appdata
	{
		float4 vertex : POSITION;
		half4 color : COLOR;
		float2 uv : TEXCOORD0;
	};

	struct v2f
	{
		float4 vertex : SV_POSITION;
		half4 color : COLOR;
		float2 uv : TEXCOORD0;
		float2 mainUV : TEXCOORD1;
		half4 uvgrab : TEXCOORD2;
	};
			
	v2f vert (appdata v)
	{
		v2f o;
		float2 offset = 0;

		o.uv.xy = TRANSFORM_TEX(v.uv, _NormalTex) + offset;

		o.vertex = UnityObjectToClipPos(v.vertex);

		o.color = v.color;

		o.uvgrab.xy = GrabScreenPosXY(o.vertex); //grabpass
		o.uvgrab.zw = o.vertex.w;

		return o;
	}
			
	half4 frag (v2f i) : SV_Target
	{
		half3 dist = UnpackNormal(tex2D(_NormalTex, i.uv));

		half2 texelSize = GetGrabTexelSize();
		half2 offset = dist.rg * _Distortion * texelSize;
		
		half3 fresnelCol = 0;

		i.uvgrab.xy = offset * i.uvgrab.z * i.color.a + i.uvgrab.xy;
		half4 grabColor = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab));;
		
		half4 result;
		result.rgb = grabColor * lerp(1, _MainColor,  i.color.a) + fresnelCol * grabColor;

		result.a = lerp(saturate(dot(fresnelCol, 0.33)*10), _MainColor.a , _MainColor.a);
		result.a *= i.color.a;

		result.a = saturate(result.a);
		return result;
	}