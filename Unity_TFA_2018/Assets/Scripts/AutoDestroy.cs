using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AutoDestroy : MonoBehaviour 
{
	public float TimeBeforeDead = 2.0f;

	// Update is called once per frame
	void Update () 
	{
		TimeBeforeDead -= Time.deltaTime;
		if(TimeBeforeDead <= 0.0f)
		{
			Destroy(gameObject);
		}
	}
}
