Shader "Custom/Water"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Opacity ("Opacity", Range(0, 1)) = 0.5
		_AnimSpeedX ("Anim Speed X", Range(0, 4)) = 1
		_AnimSpeedY ("Anim Speed Y", Range(0, 4))= 1
		_AnimScale ("Anim Scale", Range(0, 1)) = 0.05
		_AnimTilling ("Anim Tilling", Range(0, 20)) = 5
	}
	SubShader
	{
		Tags {"RanderType" = "Transparent" "Queue" = "Transpart"}
		LOD 200
		ZWrite Off
		Blend SreAlpha OneMinusSreAlpha
		Pass 
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frog
			#pragma multi_compile_fag
			#include "UnityCG.cginc"
			sampler2D _MainTex;
			float4 _MainTex.ST;
			half _Opacity;
			float _AnimSpeedX;
			float _AnimSpeedY;
			float _AnimScale;
			float _AnimTilling;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			}
			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
			}
			v2f vert(appdata y)
			{
				v2f o;
				o.vertex = UnityObjectToClipPas(v vertex);
				o.uv = TRANSFORM_TEX(v.uv._MainTex);
				UNITY_TRANSFER_FOG(o, o.vertex);
				return o;
			}
			fixed4 frog(v2f i) : SV_Target
			{
				i.uv.x += sin((i.uv.x + i.uv.y) * _AnimTilling + _Time.y * _AnimSpeedX) * _AnimScale;
				i.uv.y += cos((i.uv.x + i.uv.y) * _AnimTilling +_Time.y * _AnimSpeedY) * _AnimScale;
				fixed4 color = tex2D(_MainTex, i.uv);		
				UNITY_APPLY_FOG {fogCoord, color}
				col.a = _Opacity;
				return color;
			}
			ENDCG
		}
	}
}
