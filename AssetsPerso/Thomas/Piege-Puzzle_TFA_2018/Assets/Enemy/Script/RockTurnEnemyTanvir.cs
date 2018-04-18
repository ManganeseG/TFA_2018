using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RockTurnEnemyTanvir : MonoBehaviour 
{
	public float SpeedArmMax = 100.0f;
	public float SpeedArmMin = 20.0f;
	public float SpeedOnselfMax = 5.0f;
	public float SpeedOnselfMin = 3.0f;
	public float NewVectorNextin = 200.0f;

	private Vector3 randomVector;
	private float time;

	void Start()
	{
		time = NewVectorNextin;
		randomVector = NewRandomVector3();
	}

	void Update () 
	{
		NewVectorNextin -= Time.deltaTime;
		transform.RotateAround(transform.position,randomVector,Random.Range(SpeedArmMin,SpeedArmMax) * Time.deltaTime);
		transform.Rotate(randomVector * Random.Range(SpeedOnselfMin,SpeedOnselfMax));
		if(NewVectorNextin <= 0.0f)
		{
			randomVector = NewRandomVector3();
			NewVectorNextin = time;
		}
		if(GolemEnemy.health <= 0.0f)
			Destroy(this);
	}

	Vector3 NewRandomVector3()
	{
		randomVector = new Vector3(Random.Range(-1.0f,1.0f),Random.Range(-1.0f,1.0f),0.0f);
		return randomVector;
	}
}
