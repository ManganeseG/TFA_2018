using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NormalEnemy : MonoBehaviour 
{
	[Header ("Enemy Properties")]
    public int Score = 5;
	public float Health = 1.0f;
	public float WakeUpDistance = 5.0f;
	public float MovingSpeed = 2.0f;
	public float Radius = 0.5f;
	public float MaxDist = 10.0f;
    public float MinDist = 5.0f;

	[Header ("Wall Object")]
	public float WallCd = 5.0f;
	public GameObject WallToSpawn;
	private bool IsWall = false;
	private float pWallCd;

	private Vector3 currentForce = Vector3.zero;
	[HideInInspector]
	public Vector3 Speed = Vector3.zero;
	public Vector3 RandomDirection { get; private set; }

	[HideInInspector]
	public NormalEnemySpawner Spawner;

	private Vector3 randomDirection;
	private Vector3 previousRandomDirection;
	private float randomReset = 2.0f;
    private Vector3 playerPos;
    private Quaternion lookrotation;


    private void pickRandom()
	{
		previousRandomDirection = randomDirection;
		randomDirection = Random.onUnitSphere;
		randomDirection.y = 0f;
	}

	enum State
	{
		Sleeping,
		Moving,
		Dying
	}

	private State currentState = State.Sleeping;

	void Awake()
	{
		pickRandom();
		pickRandom();
		pWallCd = WallCd;
	}

	void Update()
	{
		float t = Time.deltaTime;
		randomReset -= t;
		if (randomReset <= 0.0f)
		{
			pickRandom();
			randomReset = 2.0f;
		}
        
		pWallCd -= t;
       	if(pWallCd <= 0.0f)
		{
			IsWall = false;
			pWallCd = WallCd;
		}
        playerPos = (Player.Current.transform.position - transform.position);
        lookrotation = Quaternion.LookRotation(playerPos);
        transform.rotation = lookrotation;
        RandomDirection = Vector3.Lerp( randomDirection, previousRandomDirection, randomReset / 2.0f);

		switch (currentState)
		{
			case State.Sleeping:
				{
                    
					float distanceToPlayer = (transform.position - Player.Current.transform.position).magnitude;
					if (distanceToPlayer <= WakeUpDistance)
						currentState = State.Moving;
				}
				break;
			case State.Moving:
				move();
			    break;
			default:
				break;
		}
	}

	private void move()
	{
		
		Speed += currentForce;
		currentForce = Vector3.zero;

        float speedMagnitude = Speed.magnitude;
		speedMagnitude = Mathf.Min(speedMagnitude, MovingSpeed);
		Speed = Speed.normalized * speedMagnitude;

		Vector3 currentPos = transform.position;

        transform.position = currentPos + Speed * Time.deltaTime;
		
		transform.LookAt(Player.Current.transform.position);

		float Dist =  (transform.position - Player.Current.transform.position).magnitude;

		if(Dist >= MinDist)
       	{
			if(Dist<= MaxDist)
			{
				MovingSpeed = 2.0f;
				if(!IsWall)
				{
					Instantiate(WallToSpawn,Player.Current.transform.position + Vector3.forward + new Vector3(0f,0.5f,0f),Quaternion.identity);
				}
				IsWall = true;
			}
			else
			{
				MovingSpeed = 5.0f;
			}
		}
	}
	
	public void AddForce(Vector3 force)
	{
		force.y = 0f;
		currentForce += force;
    }

	void OnTriggerEnter(Collider col)
	{
		if (col.gameObject.layer == LayerMask.NameToLayer("Player"))
			return;

        Health--;
		if (Health<=0f && currentState!=State.Dying)
		{
			currentState = State.Dying;
		}
	}

   
}
